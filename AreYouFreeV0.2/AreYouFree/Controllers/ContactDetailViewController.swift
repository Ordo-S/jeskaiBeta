//
//  ContactDetailViewController.swift
//  contacts
//
//  Created by Little Buddy on 11/4/18.
//  Copyright © 2018 Michael Wang. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    // Declare as var for mutability and initialize as nil.
    var contact:Contact? = nil
    
    // To know whether or not we have deleted the contact.
    var isDeleted: Bool = false
    
    var indexPath: IndexPath? = nil 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // User input to create contact
        nameLabel.text = contact?.name
        usernameLabel.text = contact?.username
    
        let cornerRad = CGFloat(25)
        deleteButton.layer.cornerRadius = cornerRad

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!


    @IBAction func done(_ sender: Any) {
        performSegue(withIdentifier: "unwindToContactList", sender: self)
    }
    
    
    
    @IBAction func deleteContact(_ sender: Any) {
        isDeleted = true
        performSegue(withIdentifier: "unwindToContactList", sender: self)
    }
    
    //MARK: - Navigation
    
    //Used to segue to Add Contact screen for editing a contact.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            guard let viewController = segue.destination as? AddContactViewController else { return }
            viewController.titleText = "Edit Contact"
            viewController.contact = contact
            viewController.indexPathForContact = self.indexPath!
        }
    }
}


