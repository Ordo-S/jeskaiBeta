//
//  AddContactViewController.swift
//  contacts
//
//  Created by Little Buddy on 11/4/18.
//  Copyright © 2018 Michael Wang. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {

    var titleText = "Add Contact"
    var contact: Contact? = nil
    // Used only for editing to make sure we don't duplicate contacts. 
    var indexPathForContact: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleText 
        // Used to populate data
        if let contact = contact {
            nameTextField.text = contact.name
            usernameTextField.text = contact.username
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    // Navigation
    
    @IBAction func save(_ sender: Any) {
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
    
}