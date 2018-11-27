//
//  InviteTableViewController.swift
//  invite
//
//  Created by Little Buddy on 11/21/18.
//  Copyright © 2018 Michael Wang. All rights reserved.
//

import UIKit
import Firebase

class InviteTableViewController: UITableViewController {
    
    // create array to hold events
    var requests: [InviteRequest] = []
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load invited events from DB
        let currentUsername = Singleton.shared.currentUsername
        ref = Database.database().reference()
        databaseHandle = ref.child(currentUsername + "/Invites").observe(.childAdded, with: { (snapshot) in
            let accepted: Bool = (snapshot.value as? Bool)!
            let name: String = snapshot.key
            let newGuy = InviteRequest(name: name, accepted: accepted)
            self.requests.append(newGuy)
            self.tableView.reloadData()
        })
        //Async will remove any removed events
        ref.child(currentUsername).observe(.childRemoved, with: { (snapshot) in
            // if child is removed, refresh the screen
            self.tableView.reloadData()
        })
        //removed static tests from micheal ||ms
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return requests.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCell", for: indexPath)
        
        let request = requests[indexPath.row]
        
        
        cell.textLabel?.text = request.name
        cell.textLabel?.textColor = UIColor.white
        
        
        // if user accepted an event, place a checkmark.
        if (request.accepted)
        {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // If there is a checkmark, remove it
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark
        {
            let request = requests[indexPath.row]
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
            //set invite status back to false in FB 
            ref.child(Singleton.shared.currentUsername + "/Invites").child(request.name).setValue(false)

        }
            
            // else add a checkmark!
        else
        {
            let request = requests[indexPath.row]
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
            //Set invite status to true in FB
            ref.child(Singleton.shared.currentUsername + "/Invites").child(request.name).setValue(true)
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
}
