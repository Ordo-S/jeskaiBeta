//
//  EditAccountViewController.swift
//  AreYouFree
//
//  Created by Mark Casapao on 11/16/18.
//  Copyright © 2018 SJSU CMPE137. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class EditAccountViewController: UIViewController {

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var resultLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        usernameTextField.layer.cornerRadius = cornerRad
        usernameTextField.layer.borderWidth = borderWidth
        usernameTextField.layer.borderColor = borderColor
        usernameTextField.clipsToBounds = true
        usernameTextField.keyboardType = .default
        
        confirmButton.layer.cornerRadius = cornerRad
        deleteButton.layer.cornerRadius = cornerRad
        cancelButton.layer.cornerRadius = cornerRad
    }

    @IBAction private func clickedConfirm(_ sender: Any) {
        resultLabel.text = "Confirming changes..."
        
        if let user = Auth.auth().currentUser {
            //Check for empty fields first
            guard let email = emailTextField.text, let username = usernameTextField.text else {
                resultLabel.text = ErrorMsg.emptyEditFields.rawValue
                return
            }
            
            if(emailTextField.text?.count==0 || usernameTextField.text?.count==0){
                resultLabel.text = ErrorMsg.emptyEditFields.rawValue
                return
            }
            
            //Username validation
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges { error in
                if let error = error {
                    // An error happened.
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .requiresRecentLogin:
                            self.resultLabel.text = ErrorMsg.requiresRecentLogin.rawValue
                        case .tooManyRequests:
                            self.resultLabel.text = ErrorMsg.tooManyRequests.rawValue
                        case .networkError:
                            self.resultLabel.text = ErrorMsg.networkError.rawValue
                        case .userTokenExpired:
                            self.resultLabel.text = ErrorMsg.userTokenExpired.rawValue
                        default:
                            self.resultLabel.text = ErrorMsg.updateAccountDefault.rawValue
                        }
                    }
                    return
                }
            }
            
            //Email validation
            Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                if let error = error {
                    // An error happened.
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .emailAlreadyInUse:
                            self.resultLabel.text = ErrorMsg.emailAlreadyInUse.rawValue
                        case .invalidEmail:
                            self.resultLabel.text = ErrorMsg.invalidEmail.rawValue
                        case .requiresRecentLogin:
                            self.resultLabel.text = ErrorMsg.requiresRecentLogin.rawValue
                        case .tooManyRequests:
                            self.resultLabel.text = ErrorMsg.tooManyRequests.rawValue
                        case .networkError:
                            self.resultLabel.text = ErrorMsg.networkError.rawValue
                        case .userTokenExpired:
                            self.resultLabel.text = ErrorMsg.userTokenExpired.rawValue
                        default:
                            self.resultLabel.text = ErrorMsg.updateAccountDefault.rawValue
                        }
                    }
                    return
                } else {
                    //By now, the updates are confirmed to be working.
                    self.performSegue(withIdentifier: "unwindToSettings", sender: self)
                }
            }
        } else {
            resultLabel.text = ErrorMsg.updateAccountDefault.rawValue
        }
    }
    
    @IBAction private func clickedDeleteAccount(_ sender: Any) {
        //Code credits based on https://stackoverflow.com/questions/25511945/swift-alert-view-ios8-with-ok-and-cancel-button-which-button-tapped
        let refreshAlert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account? You won't be able to get it back.", preferredStyle: UIAlertController.Style.alert)
        
        //When they click yes
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.resultLabel.text = "Deleting account..."
            let user = Auth.auth().currentUser
            user?.delete { error in
                if let error = error {
                    // An error happened.
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .requiresRecentLogin:
                            self.resultLabel.text = ErrorMsg.requiresRecentLogin.rawValue
                        case .tooManyRequests:
                            self.resultLabel.text = ErrorMsg.tooManyRequests.rawValue
                        case .networkError:
                            self.resultLabel.text = ErrorMsg.networkError.rawValue
                        case .userTokenExpired:
                            self.resultLabel.text = ErrorMsg.userTokenExpired.rawValue
                        default:
                            self.resultLabel.text = ErrorMsg.deleteAccountDefault.rawValue
                        }
                    }
                } else {
                    // Account deleted.
                    //Log out of Facebook
                    FBSDKAccessToken.setCurrent(nil)
                    //Segue
                    self.performSegue(withIdentifier: "goToLogin", sender: self)
                }
            }
        }))
        
        //When they click no
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
           //Do nothing
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction private func clickedCancel(_ sender: Any) {
        performSegue(withIdentifier: "unwindToSettings", sender: self)
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
