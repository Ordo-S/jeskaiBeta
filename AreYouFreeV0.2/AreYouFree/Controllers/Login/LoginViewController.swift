//
//  ViewController.swift
//  AreYouFree
//
//  Created by Mark Casapao on 9/20/18.
//  Copyright © 2018 SJSU CMPE137. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FBSDKLoginKit
class LoginViewController: UIViewController {

    //Firebase and widget properties
    private var ref: DatabaseReference!
    @IBOutlet private weak var loginSelector : UISegmentedControl!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var facebookLoginButton: UIButton!
    @IBOutlet private weak var recoveryButton: UIButton!
    
    //Login lockout properties
    private var failedLoginAttempts = 0
    private let failedAttemptsLimit = 3
    private let lockoutDurationInSeconds = 30
    private var timerSeconds = 30
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Check if user is signed in via Facebook login
        if Auth.auth().currentUser != nil {
            // User is signed in.
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryBoard.instantiateViewController(withIdentifier: "HomeView")
            self.present(homeViewController, animated: true, completion: nil)
        } else {
            // No user is signed in.
        }
    }
    
    //Initial setup of UI
    private func setUpUI() {
        self.hideKeyboardWhenTappedAround()
        
        let cornerRad = CGFloat(25)
        let borderWidth = CGFloat(1)
        let borderColor = UIColor.gray.cgColor
        
        emailTextField.layer.cornerRadius = cornerRad
        emailTextField.layer.borderWidth = borderWidth
        emailTextField.layer.borderColor = borderColor
        emailTextField.clipsToBounds = true
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.layer.cornerRadius = cornerRad
        passwordTextField.layer.borderWidth = borderWidth
        passwordTextField.layer.borderColor = borderColor
        passwordTextField.clipsToBounds = true
        passwordTextField.keyboardType = .default
        
        signInButton.layer.cornerRadius = cornerRad
        
        facebookLoginButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
    }
    
    @objc private func handleCustomFBLogin() {
        loginLabel.text = "Logging in to Facebook..."
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, error) in
            //Facebook errors checked here
            if error != nil {
                self.loginLabel.text = error!.localizedDescription
                return
            }
            
            //Firebase errors here
            if FBSDKAccessToken.current() != nil {
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                    if let error = error {
                        if let errCode = AuthErrorCode(rawValue: error._code) {
                            switch errCode {
                            case .invalidCredential:
                                self.loginLabel.text = ErrorMsg.invalidCredential.rawValue
                            case .invalidEmail:
                                self.loginLabel.text = ErrorMsg.invalidEmail.rawValue
                            case .emailAlreadyInUse:
                                self.loginLabel.text = ErrorMsg.emailAlreadyInUse.rawValue
                            case .wrongPassword:
                                self.loginLabel.text = ErrorMsg.wrongPassword.rawValue
                            case .tooManyRequests:
                                self.loginLabel.text = ErrorMsg.tooManyRequests.rawValue
                            case .networkError:
                                self.loginLabel.text = ErrorMsg.networkError.rawValue
                            case .userTokenExpired:
                                self.loginLabel.text = ErrorMsg.userTokenExpired.rawValue
                            default:
                                self.loginLabel.text = ErrorMsg.fbLoginDefault.rawValue
                            }
                        }
                        return
                    }
                    // User is signed in
                    self.loginLabel.text = "Facebook login Success!"
                    self.performSegue(withIdentifier: "goToHome", sender: self) //we use self. because this is inside a closure
                }
            } else {
                self.loginLabel.text = ErrorMsg.fbLoginDefault.rawValue
            }
        }
    }
    
    @IBAction private func recoveryClicked(_ sender: Any) {
        performSegue(withIdentifier: "goToRecovery", sender: self)
    }
    
    //Activates when you change the value of the selector
    @IBAction private func loginSelectorChanged(_ sender: UISegmentedControl) {
        let selectedIndex = loginSelector.selectedSegmentIndex //finds the index of selector
        switch selectedIndex {
        case 0: //0 means sign in
            loginLabel.text = LoginButtonMsg.signIn.rawValue
            signInButton.setLoginButtonTitleToSignIn(signIn: true)
        case 1: //1 means register
            loginLabel.text = LoginButtonMsg.register.rawValue
            signInButton.setLoginButtonTitleToSignIn(signIn: false)
        default:
            print("Somehow you chose a button in the selector that doesn't exist!")
        }
        resetMenu()
    }
    
    @IBAction private func signInClicked(_ sender: UIButton) {
        //Check if email and password are filled in
        if let email = emailTextField.text, let pass = passwordTextField.text {
            //Check if you're doing sign in or register
            let selectedIndex = loginSelector.selectedSegmentIndex //finds the index of selector
            switch selectedIndex {
                
            case 0: //0 means sign in
                Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                    //Validation begins here
                    if (email.count == 0 || pass.count == 0){
                        self.loginLabel.text = ErrorMsg.emptyLoginFields.rawValue
                    } else if error != nil {
                        //Handle error
                        if let errCode = AuthErrorCode(rawValue: error!._code) {
                            switch errCode {
                            case .userNotFound:
                                self.loginLabel.text = ErrorMsg.userNotFound.rawValue
                            case .invalidEmail:
                                self.loginLabel.text = ErrorMsg.invalidEmail.rawValue
                            case .wrongPassword:
                                self.loginLabel.text = ErrorMsg.wrongPassword.rawValue
                                self.failedLoginAttempt()
                            case .tooManyRequests:
                                self.loginLabel.text = ErrorMsg.tooManyRequests.rawValue
                            case .networkError:
                                self.loginLabel.text = ErrorMsg.networkError.rawValue
                            case .userTokenExpired:
                                self.loginLabel.text = ErrorMsg.userTokenExpired.rawValue
                            default:
                                self.loginLabel.text = ErrorMsg.loginDefault.rawValue
                            }
                        }
                    } else {
                        //Validation successful
                        self.performSegue(withIdentifier: "goToHome", sender: self) //we use self. because this is inside a closure
                    }
                }
                
            case 1: //1 means register
                Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                    //Validation begins here
                    if (email.count == 0 || pass.count == 0){
                        self.loginLabel.text = ErrorMsg.emptyLoginFields.rawValue
                    } else if error != nil {
                        //Handle error
                        if let errCode = AuthErrorCode(rawValue: error!._code) {
                            switch errCode {
                            case .invalidEmail:
                                self.loginLabel.text = ErrorMsg.invalidEmail.rawValue
                            case .emailAlreadyInUse:
                                self.loginLabel.text = ErrorMsg.emailAlreadyInUse.rawValue
                            case .weakPassword:
                                self.loginLabel.text = ErrorMsg.weakPassword.rawValue
                            case .tooManyRequests:
                                self.loginLabel.text = ErrorMsg.tooManyRequests.rawValue
                            case .networkError:
                                self.loginLabel.text = ErrorMsg.networkError.rawValue
                            default:
                                self.loginLabel.text = ErrorMsg.registerDefault.rawValue
                            }
                        }
                    } else {
                        //Validation successful
                        self.performSegue(withIdentifier: "goToHome", sender: self) //we use self. because this is inside a closure
                    }
                }
                
            default:
                print("Somehow you chose a button in the selector that doesn't exist!")
            }
        }
    }
    
    //Used for clearing the text fields when user switches from register and sign in
    private func resetMenu(){
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    //Called when the user places an mismatched credential
    private func failedLoginAttempt(){
        //Count up all the failed attempts and check if it passed the limit
        failedLoginAttempts += 1
        if (failedLoginAttempts >= failedAttemptsLimit) {
            //Disable widgets first
            failedLoginAttempts = 0
            loginSelector.isEnabled = false
            signInButton.disableLoginButton()
            emailTextField.disableLoginTextField()
            passwordTextField.disableLoginTextField()
            facebookLoginButton.disableFBButton()
            recoveryButton.disableRecoveryButton()
            
            //Begin timer
            startTimer()
        }
    }
    
    //This code is inspired from this source: https://medium.com/ios-os-x-development/build-an-stopwatch-with-swift-3-0-c7040818a10f
    private func startTimer(){
        timerSeconds = lockoutDurationInSeconds
        loginLabel.text = "Too many failed logins. Retry in \(timerSeconds) seconds."
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LoginViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer(){
        //If we're done locking out...
        if timerSeconds < 1 {
            //Turn off timer and re-enable widgets
            timer.invalidate()
            loginLabel.text = LoginButtonMsg.signIn.rawValue
            loginSelector.isEnabled = true
            signInButton.enableLoginButton()
            emailTextField.enableLoginTextfield()
            passwordTextField.enableLoginTextfield()
            facebookLoginButton.enableFBButton()
            recoveryButton.enableRecoveryButton()
            
        } else {
            //Otherwise keep counting down and updating the message
            timerSeconds -= 1
            loginLabel.text = "Too many failed logins. Retry in \(timerSeconds) seconds."
        }
    }
    
    //Orientation lock purposes
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    //Releasing orientation lock purposes
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    //Set status bar to white icons
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//This enum contains all the strings used for the error messages
enum ErrorMsg: String {
    case invalidEmail = "Invalid email format."
    case emailAlreadyInUse = "Email account already exists."
    case weakPassword = "Password is too weak."
    case tooManyRequests = "Too many requests. Please wait before retrying."
    case networkError = "Network error. Please reconnect to internet."
    case userNotFound = "User not found."
    case wrongPassword = "Incorrect password."
    case userTokenExpired = "User token has expired."
    case emptyLoginFields = "Email/password fields can't be empty."
    case emptyEditFields = "User fields can't be empty."
    case invalidCredential = "Invalid credentials."
    case requiresRecentLogin = "Updating/deleting requires recent log in."
    case invalidSender = "Invalid sender email."
    case invalidRecipientEmail = "Invalid recipient email."
    case fbLoginDefault = "Facebook login failed."
    case loginDefault = "Login failed."
    case registerDefault = "Regisration failed."
    case deleteAccountDefault = "Account deletion failed."
    case updateAccountDefault = "Account update failed."
    case recoverAccountDefault = "Account recovery email failed."
}

//This enum contains all the strings used for the login prompt messages
private enum LoginButtonMsg: String {
    case signIn = "Please Sign In."
    case register = "Please Register."
}

private func printUserInfo() {
    //Debugging purposes
    let user = Auth.auth().currentUser
    if let user = user {
        print(user.displayName ?? "Couldn't get display name.")
        print(user.email ?? "Couldn't get email.")
    }
}
