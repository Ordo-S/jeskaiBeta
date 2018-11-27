//
//  RecoveryViewController.swift
//  AreYouFree
//
//  Created by Mark Casapao on 11/17/18.
//  Copyright © 2018 SJSU CMPE137. All rights reserved.
//

import UIKit
import Firebase

class RecoveryViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    
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
        
        confirmButton.layer.cornerRadius = cornerRad
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    @IBAction func confirmClicked(_ sender: Any) {
        guard let email = emailTextField.text, emailTextField.text?.count != 0 else {
            resultLabel.text = ErrorMsg.emptyEditFields.rawValue
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                //error
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .invalidEmail:
                        self.resultLabel.text = ErrorMsg.invalidEmail.rawValue
                    case .userNotFound:
                        self.resultLabel.text = ErrorMsg.userNotFound.rawValue
                    case .invalidSender:
                        self.resultLabel.text = ErrorMsg.invalidSender.rawValue
                    case .invalidRecipientEmail:
                        self.resultLabel.text = ErrorMsg.invalidRecipientEmail.rawValue
                    case .tooManyRequests:
                        self.resultLabel.text = ErrorMsg.tooManyRequests.rawValue
                    case .networkError:
                        self.resultLabel.text = ErrorMsg.networkError.rawValue
                    case .userTokenExpired:
                        self.resultLabel.text = ErrorMsg.userTokenExpired.rawValue
                    default:
                        self.resultLabel.text = ErrorMsg.recoverAccountDefault.rawValue
                    }
                }
            } else {
                //email successful
                self.resultLabel.text = "Email successfully sent."
            }
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
    
    //Set status bar to white icons
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
