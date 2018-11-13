//
//  Extensions.swift
//  AreYouFree
//
//  Created by Mark Casapao on 11/12/18.
//  Copyright © 2018 SJSU CMPE137. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIButton {
    func disableLoginButton() {
        self.isEnabled = false
        self.backgroundColor = #colorLiteral(red: 0, green: 0.9866840243, blue: 0, alpha: 0.5)
    }
    
    func enableLoginButton() {
        self.isEnabled = true
        self.backgroundColor = #colorLiteral(red: 0, green: 0.9866840243, blue: 0, alpha: 1)
    }
    
    func setLoginButtonTitleToSignIn(signIn: Bool){
        if (signIn) {
            self.setTitle("Sign In", for: .normal)
        } else {
            self.setTitle("Register", for: .normal)
        }
    }
}

extension UITextField {
    func disableLoginTextField() {
        self.isEnabled = false
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    func enableLoginTextfield() {
        self.isEnabled = true
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.borderColor = UIColor.gray.cgColor
    }
}
