//
//  ContactsViewController.swift
//  contacts
//
//  Created by Little Buddy on 11/4/18.
//  Copyright © 2018 Michael Wang. All rights reserved.
//

import UIKit
import FirebaseDatabase

// The Firebase DB uses key-value pairs
class ContactsViewController: UITableViewController {
    
    var contacts: [Contact] = []
    var databaseHandle:DatabaseHandle?
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Luke's code is starting here
        let currentUserID = Singleton.shared.currentUserID
        ref = Database.database().reference()
        databaseHandle = ref.child(currentUserID + "/Contacts").observe(.childAdded, with: { (snapshot) in
            let username: String = (snapshot.value as? String)!
            let name: String = snapshot.key
            let newGuy = Contact(name: name, username: username)
            self.contacts.append(newGuy)
            self.tableView.reloadData()
        })
        
        ref.child(currentUserID + "/Contacts").observe(.childRemoved, with: { (snapshot) in
            // if child is removed, refresh the screen
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #return the number of rows (number of contacts we have!)
        return contacts.count
    }
    
    // Number of cells we are going to use.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        
        let contact = contacts[indexPath.row]
        
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.username
        
        
        // Return a UI tableView cell
        return cell
    }
    
    //MARK: - Navigation
    
    // Return to Contacts List.
    @IBAction func unwindToContactList(segue: UIStoryboardSegue){
    
    // We want it to cast as the AddContactViewController as it has text fields!
        let currentUserID = Singleton.shared.currentUserID
        
        // If both text fields are filled (name and username) and it came from AddContactViewController, make a contact!
        if let viewController = segue.source as? AddContactViewController {
        guard let name = viewController.nameTextField.text else { return }
        guard let username = viewController.usernameTextField.text else { return }
        let contact = Contact(name: name, username: username)
            // If name and username text fields are filled.
            if name != "" && username != "" {
                if let IndexPath = viewController.indexPathForContact {
                    contacts[IndexPath.row] = contact
                } else {
                    // contacts.append(contact)
                    // here I am adding a new contact to the DB
                    ref.child(currentUserID + "/Contacts").child(contact.name).setValue(username)
                }
            }
        tableView.reloadData()
            
        } else if let viewController = segue.source as? ContactDetailViewController {
            if viewController.isDeleted{
                guard let indexPath: IndexPath = viewController.indexPath else { return }
                let tempContact = contacts[indexPath.row].name  // tempContact is holding the name of the contact we are about to delete
                contacts.remove(at: indexPath.row)
                ref.child(currentUserID + "/Contacts").child(tempContact).removeValue() // this removes the contact from our DB
                
                tableView.reloadData()
            }
        }
    
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Makes sure that segue is contactDetailSegue and not AddContact
        
        if segue.identifier == "contactDetailSegue" {
            

            // if contactDetailSegue is not talking to the ContactDetailViewController... return
            guard let viewController = segue.destination as? ContactDetailViewController else { return }
            
            // Make sure it is unwrapped! If we do not know which row is selected, we won't know which contact to pass on!
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let contact = contacts[indexPath.row]
            viewController.contact = contact
            viewController.indexPath = indexPath
            
        }
    }

}

