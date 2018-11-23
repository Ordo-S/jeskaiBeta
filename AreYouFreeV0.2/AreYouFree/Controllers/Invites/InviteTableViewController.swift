//
//  InviteTableViewController.swift
//  invite
//
//  Created by Little Buddy on 11/21/18.
//  Copyright © 2018 Michael Wang. All rights reserved.
//

import UIKit

class InviteTableViewController: UITableViewController {
    
    // create array to hold events
    var requests: [InviteRequest] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load events
        
        let request1 = InviteRequest(name: "Event 1", accepted: true)
        requests.append(request1)
        
        let request2 = InviteRequest(name: "Event 2", accepted: false)
        requests.append(request2)
        
        let request3 = InviteRequest(name: "Event 3", accepted: true)
        requests.append(request3)
        
        let request4 = InviteRequest(name: "Event 4", accepted: false)
        requests.append(request4)
        
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
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }
            
            // else add a checkmark!
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
    }
}
