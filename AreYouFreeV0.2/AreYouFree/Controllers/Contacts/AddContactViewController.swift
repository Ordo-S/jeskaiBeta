//
//  AddContactViewController.swift
//  contacts
//
//  Created by Little Buddy on 11/4/18.
//  Copyright © 2018 Michael Wang. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddContactViewController: UIViewController {

    var titleText = "Add Contact"
    var contact: Contact? = nil
    // Used only for editing to make sure we don't duplicate contacts. 
    var indexPathForContact: IndexPath? = nil
    var ref: DatabaseReference!
    var tempName: String? = nil
    var replaced: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        titleLabel.text = titleText 
        // Used to populate data
        if let contact = contact {
            nameTextField.text = contact.name
            usernameTextField.text = contact.username
        }
        
        
        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    //Initial setup of UI
    private func setUpUI() {
        self.hideKeyboardWhenTappedAround()
        
        let cornerRad = CGFloat(25)
        let borderWidth = CGFloat(1)
        let borderColor = UIColor.gray.cgColor
        
        nameTextField.layer.cornerRadius = cornerRad
        nameTextField.layer.borderWidth = borderWidth
        nameTextField.layer.borderColor = borderColor
        nameTextField.clipsToBounds = true
        
        usernameTextField.layer.cornerRadius = cornerRad
        usernameTextField.layer.borderWidth = borderWidth
        usernameTextField.layer.borderColor = borderColor
        usernameTextField.clipsToBounds = true
        
        cancelButton.layer.cornerRadius = cornerRad
        saveButton.layer.cornerRadius = cornerRad
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    // Navigation
    @IBAction func save(_ sender: Any) {
        //Mark's fix
        if nameTextField.text != nil && usernameTextField.text != nil {
            ref.child(Singleton.shared.currentUserID + "/Contacts").child(nameTextField.text!).setValue(usernameTextField.text)
        }
        
        if tempName != nil, tempName != nameTextField.text {
            ref.child(Singleton.shared.currentUserID + "/Contacts").child(tempName!).removeValue()// this removes the contact from our DB
            replaced = true
        }
        
        performSegue(withIdentifier: "unwindToContactList", sender: self)
    }
    
    @IBAction func close(_ sender: Any) {
        //Don't save contact if user cancels. 
        nameTextField.text = nil
        usernameTextField.text = nil
        //https://www.youtube.com/watch?v=qfupg-OeY94
        //30:14
        //51:00
        performSegue(withIdentifier: "unwindToContactList", sender: self)

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
}
