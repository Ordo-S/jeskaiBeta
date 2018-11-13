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

class LoginViewController: UIViewController {

    //Firebase and widget properties
    var ref: DatabaseReference!
    @IBOutlet weak var loginSelector : UISegmentedControl!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
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
    }
    
    //Activates when you change the value of the selector
    @IBAction func loginSelectorChanged(_ sender: UISegmentedControl) {
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
    
    @IBAction func signInClicked(_ sender: UIButton) {
        //Check if email and password are filled in
        if let email = emailTextField.text, let pass = passwordTextField.text {
            //Check if you're doing sign in or register
            let selectedIndex = loginSelector.selectedSegmentIndex //finds the index of selector
            switch selectedIndex {
                
            case 0: //0 means sign in
                Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                    //Validation begins here
                    if (email.count == 0 || pass.count == 0){
                        self.loginLabel.text = ErrorMsg.emptyFields.rawValue
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
                                print("Uncommon User Error: \(error!)")
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
                        self.loginLabel.text = ErrorMsg.emptyFields.rawValue
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
                                print("Uncommon User Error: \(error!)")
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
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    //Releasing orientation lock purposes
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
}

//This enum contains all the strings used for the error messages
private enum ErrorMsg: String {
    case invalidEmail = "Invalid email format."
    case emailAlreadyInUse = "Email account already exists."
    case weakPassword = "Password is too weak."
    case tooManyRequests = "Too many requests. Please wait before retrying."
    case networkError = "Network error. Please reconnect to internet."
    case userNotFound = "User email not found."
    case wrongPassword = "Incorrect password."
    case userTokenExpired = "User token has expired. Please retry."
    case emptyFields = "Email/password fields can't be empty."
}

//This enum contains all the strings used for the login prompt messages
private enum LoginButtonMsg: String {
    case signIn = "Please Sign In."
    case register = "Please Register."
}
