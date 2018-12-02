//
//  HomepageViewController.swift
//  AreYouFree
//
//  Created by Mark Casapao on 10/20/18.
//  Copyright © 2018 SJSU CMPE137. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

class SettingsPageViewController: UIViewController {

    @IBOutlet private var signOutButton: UIButton!
    @IBOutlet private weak var editAccountButton: UIButton!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        signOutButton.layer.cornerRadius = CGFloat(25)
        editAccountButton.layer.cornerRadius = CGFloat(25)
        usernameLabel.text = "Username: " + Singleton.shared.currentUsername
        emailLabel.text = "Email: " + Singleton.shared.currentUserEmail
    }
    
    @IBAction private func signOutClicked(_ sender: UIButton) {
        //Log out of Firebase
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        //Log out of Facebook
        FBSDKAccessToken.setCurrent(nil)
        
        //Segue
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    @IBAction func unwindToSettings(segue: UIStoryboardSegue){
        usernameLabel.text = "Username: " + Singleton.shared.currentUsername
        emailLabel.text = "Email: " + Singleton.shared.currentUserEmail
    }
    
    @IBAction private func editClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "goToEditAccount", sender: self)
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
