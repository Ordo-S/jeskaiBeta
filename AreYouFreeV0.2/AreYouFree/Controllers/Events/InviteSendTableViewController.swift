//
//  InviteTableViewController.swift
//  AreYouFree
//
//  Created by Matt Spadaro on 11/22/18.
//  Copyright © 2018 SJSU CMPE137. All rights reserved.
//

import UIKit
import FirebaseDatabase
import os.log

// The Firebase DB uses key-value pairs
class InviteSendTableViewController: UITableViewController {
    //Mark: Properties
    var event: event?
    var contacts: [Contact] = []
    var databaseHandle:DatabaseHandle?
    var ref: DatabaseReference!
    //used for invitng people to event
    var hasCheckmark: [Int] = []
    @IBOutlet weak var saveButton: UIBarButtonItem!
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
        //init the array to be full of 0
        hasCheckmark = Array(repeating: 0, count: contacts.count)
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
    //To select contacts from your list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            hasCheckmark[indexPath.row] = 0
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            hasCheckmark[indexPath.row] = 1
        }
    }
    //Mark: Actions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        print("Event: ",event?.name ?? "Error in getting event name")
        print("Contacts Invited")
        for i in 0...hasCheckmark.count-1 {
            if hasCheckmark[i] == 1{
                let path = IndexPath(row: i, section: i)
                let contact = contacts[path.row]
                print(contact.name)
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
}
