//
//  MealTableViewController.swift
//  areYouFreev2
//
//  Created by Matt Spadaro on 11/11/18.
//  Copyright © 2018 Group 1. All rights reserved.
//

import UIKit
import CoreLocation
import os.log

class EventTableViewController: UITableViewController {
    //Mark: Properties
    var Events = [event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load Sample Events, for testing 
       // loadSampleEvent()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "EventTableViewCell"

        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell  else {
            fatalError("The dequeued cell is not an instance of EventTableViewCell.")
        }
        
        // Fetches the appropriate event for the data source layout.
        let Event = Events[indexPath.row]
        //let lat = Event.calculateLat()
       // let lon = Event.calculateLon()
        
        cell.eventLabel.text = Event.name
        cell.photoImageView.image = Event.photo
       // cell.latitude = lat
       // cell.longitude = lon
        
        
        return cell
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            Events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //From Apples docs on how to send to segue
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new event.", log: OSLog.default, type: .debug)
            
        case "EventDetail":
            //taken from apple docs exactly modifed for project use
            guard let ViewController = segue.destination as? EventDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedEventCell = sender as? EventTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedEventCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedEvent = Events[indexPath.row]
            ViewController.event = selectedEvent
            os_log("Veiwing Event detail", log: OSLog.default, type: .debug)
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
 
    //MARK: Actions
    @IBAction func unwindTEventList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewController, let Event = sourceViewController.Event {
            //Events is Local
            //Event is from EventView super confusing I know
            
            //How to chouse how to segue to the event view
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing event.
                Events[selectedIndexPath.row] = Event
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new event.
                let newIndexPath = IndexPath(row: Events.count, section: 0)
                
                Events.append(Event)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    @IBAction func unwindToEvents(segue: UIStoryboardSegue) {
        //Do nothing
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
    
    //MARK: Private Methods
    /*Used for testing
    private func loadSampleEvent() {
        //setting up sample photos
        let photo1 = UIImage(named: "event1")
        let photo2 = UIImage(named: "event2")
        let photo3 = UIImage(named: "event3")
        
        guard let event1 = event(name: "Event One", photo: photo1!) else{
            fatalError("Unable to create event")
        }
        guard let event2 = event(name: "Event Two", photo: photo2!) else{
            fatalError("Unable to create evnet")
        }
        guard let event3 = event(name: "Event Threee", photo: photo3!) else {
            fatalError("Unable to create event")
        }
        
        Event += [event1, event2, event3]
        
    }

}

}*/
}
