//
//  ContactDetailViewController.swift
//  contacts
//
//  Created by Little Buddy on 11/4/18.
//  Copyright © 2018 Michael Wang. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    var contact:Contact? = nil// Declare as var for mutability and initialize as nil.
    var isDeleted: Bool = false// To know whether or not we have deleted the contact.
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
            viewController.tempName = contact?.name
        }
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


