//
//  ContactsViewController.swift
//  contacts
//
//  Created by Little Buddy on 11/4/18.
//  Copyright © 2018 Michael Wang. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {
    
    var contacts: [Contact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let michael = Contact(name: "Michael", username: "mwmichaelwang")
        contacts.append(michael)
        
        let mark = Contact(name: "Mark", username: "FiNalStaR")
        contacts.append(mark)
        
        let matt = Contact(name: "Matt", username: "Ordo")
        contacts.append(matt)
        
        let luke = Contact(name: "Luke", username: "lastjediluke")
        contacts.append(luke)
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
        if let viewController = segue.source as? AddContactViewController {
        
        // If both text fields are filled (name and username) and it came from AddContactViewController, make a contact!
        guard let name = viewController.nameTextField.text else { return }
        guard let username = viewController.usernameTextField.text else { return }
        let contact = Contact(name: name, username: username)
            // If name and username text fields are filled.
            if name != "" && username != "" {
                if let IndexPath = viewController.indexPathForContact {
                    contacts[IndexPath.row] = contact
                } else {
                    contacts.append(contact)
                }
            }
        tableView.reloadData()
            
        } else if let viewController = segue.source as? ContactDetailViewController {
            if viewController.isDeleted{
                guard let indexPath: IndexPath = viewController.indexPath else { return }
                contacts.remove(at: indexPath.row)
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

