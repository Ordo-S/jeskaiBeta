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
        let cornerRad = CGFloat(25)
        let borderWidth = CGFloat(1)
        let borderColor = UIColor.gray.cgColor
        emailTextField.layer.cornerRadius = cornerRad
        emailTextField.layer.borderWidth = borderWidth
        emailTextField.layer.borderColor = borderColor
        emailTextField.clipsToBounds = true
        
        passwordTextField.layer.cornerRadius = cornerRad
        passwordTextField.layer.borderWidth = borderWidth
        passwordTextField.layer.borderColor = borderColor
        passwordTextField.clipsToBounds = true
        
        signInButton.layer.cornerRadius = cornerRad
    }
    
    //Activates when you change the value of the selector
    @IBAction func loginSelectorChanged(_ sender: UISegmentedControl) {
        let selectedIndex = loginSelector.selectedSegmentIndex //finds the index of selector
        switch selectedIndex {
        case 0: //0 means sign in
            loginLabel.text = "Please Sign In."
            signInButton.setTitle("Sign In", for: .normal)
        case 1: //1 means register
            loginLabel.text = "Please Register."
            signInButton.setTitle("Register", for: .normal)
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
                        self.loginLabel.text = "Email/password fields can't be empty."
                    } else if error != nil {
                        //Handle error
                        if let errCode = AuthErrorCode(rawValue: error!._code) {
                            switch errCode {
                            case .userNotFound:
                                self.loginLabel.text = "User email not found."
                            case .invalidEmail:
                                self.loginLabel.text = "Invalid email format."
                            case .wrongPassword:
                                self.loginLabel.text = "Incorrect password."
                                self.failedLoginAttempt()
                            case .tooManyRequests:
                                self.loginLabel.text = "Too many requests. Please wait before retrying."
                            case .networkError:
                                self.loginLabel.text = "Network error. Please reconnect to internet."
                            case .userTokenExpired:
                                self.loginLabel.text = "User token has expired. Please retry."
                            default:
                                print("User Error: \(error!)")
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
                        self.loginLabel.text = "Email/password fields can't be empty."
                    } else if error != nil {
                        //Handle error
                        if let errCode = AuthErrorCode(rawValue: error!._code) {
                            switch errCode {
                            case .invalidEmail:
                                self.loginLabel.text = "Invalid email format."
                            case .emailAlreadyInUse:
                                self.loginLabel.text = "Email account already exists."
                            case .weakPassword:
                                self.loginLabel.text = "Password is too weak."
                            case .tooManyRequests:
                                self.loginLabel.text = "Too many requests. Please wait before retrying."
                            case .networkError:
                                self.loginLabel.text = "Network error. Please reconnect to internet."
                            default:
                                print("User Error: \(error!)")
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
            //resetMenu()
        }
    }
    
    private func resetMenu(){
        emailTextField.text = ""
        passwordTextField.text = ""
        failedLoginAttempts = 0
    }
    
    private func failedLoginAttempt(){
        //Count up all the failed attempts and check if it passed the limit
        failedLoginAttempts += 1
        if (failedLoginAttempts >= failedAttemptsLimit) {
            //Disable widgets first
            failedLoginAttempts = 0
            loginSelector.isEnabled = false
            signInButton.isEnabled = false
            signInButton.backgroundColor = #colorLiteral(red: 0, green: 0.9866840243, blue: 0, alpha: 0.5)
            emailTextField.isEnabled = false
            emailTextField.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            passwordTextField.isEnabled = false
            passwordTextField.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
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
        if timerSeconds < 1 {
            //Turn off timer and re-enable widgets
            timer.invalidate()
            loginLabel.text = "Please Sign In."
            loginSelector.isEnabled = true
            signInButton.isEnabled = true
            signInButton.backgroundColor = #colorLiteral(red: 0, green: 0.9866840243, blue: 0, alpha: 1)
            emailTextField.isEnabled = true
            emailTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passwordTextField.isEnabled = true
            passwordTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        } else {
            timerSeconds -= 1
            loginLabel.text = "Too many failed logins. Retry in \(timerSeconds) seconds."
        }
    }
}

