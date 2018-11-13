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

    var ref: DatabaseReference!
    @IBOutlet weak var loginSelector : UISegmentedControl!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
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
                            case .invalidEmail:
                                self.loginLabel.text = "Invalid email."
                            case .wrongPassword:
                                self.loginLabel.text = "Incorrect password."
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
                                self.loginLabel.text = "Invalid email."
                            case .emailAlreadyInUse:
                                self.loginLabel.text = "Email account already exists."
                            case .weakPassword:
                                self.loginLabel.text = "Password is too weak."
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
    
    private func resetMenu() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}

