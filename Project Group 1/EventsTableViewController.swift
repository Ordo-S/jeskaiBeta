//
//  ViewController.swift
//  Project Group 1
//
//  Created by Ordo on 9/20/18.
//  Copyright © 2018 Group1. All rights reserved.
//

import UIKit
import CloudKit

struct Event {
    //record type for cloud kit
    fileprivate static let recordType = "Event"
    //key
    fileprivate static let keys = (name : "name")
    //cloud kit record
    var record : CKRecord
    //init for storage
    init(record : CKRecord) {
        self.record = record
    }
    
    init() {
        self.record = CKRecord(recordType: Event.recordType)
    }
    //stor in ck
    var name : String {
        get {
            return self.record.value(forKey: Event.keys.name) as! String
        }
        set {
            self.record.setValue(newValue, forKey: Event.keys.name)
        }
    }
}

class EventsModel {
    //set our db
    private let database = CKContainer.default().privateCloudDatabase
    
    var events = [Event()] {
        didSet {
            self.notificationQueue.addOperation {
                self.onChange?()
            }
        }
    }
    
    var onChange : (() -> Void)?
    var onError : ((Error) -> Void)?
    var notificationQueue = OperationQueue.main
    
    var records = [CKRecord]()
    var insertedObjects = [Event]()
    var deletedObjectIds = Set<CKRecord.ID>()
    
    private func handle(error: Error) {
        self.notificationQueue.addOperation {
            self.onError?(error)
        }
    }

    
    init() {
    }
    
    
    //add in event
    func addEvent(name : String) {
        var event = Event()
        event.name = name
        database.save(event.record) { _, error in //else on eror handle
            guard error == nil else {
                self.handle(error: error!)
                return
            }
        }
        self.insertedObjects.append(event)
        //to refersh app when it event is added
        self.updateEvents()
    }
    //remove a event
    func delete(at index : Int) {
        let recordId = self.events[index].record.recordID
        database.delete(withRecordID: recordId) { _, error in
            guard error == nil else {
                self.handle(error: error!)
                return
            }
        }
        deletedObjectIds.insert(recordId)
        updateEvents()
    }
    //
    private func updateEvents() {
        
        var knownIds = Set(records.map { $0.recordID })
        
        // remove objects from our local list once we see them returned from the cloudkit storage
        self.insertedObjects.removeAll { event in
            knownIds.contains(event.record.recordID)
        }
        knownIds.formUnion(self.insertedObjects.map { $0.record.recordID })
        
        // remove objects from our local list once we see them not being returned from storage anymore
        self.deletedObjectIds.formIntersection(knownIds)
        
        var events = records.map { record in Event(record: record) }
        
        events.append(contentsOf: self.insertedObjects)
        events.removeAll { event in
            deletedObjectIds.contains(event.record.recordID)
        }
        
       self.events = events
        
        debugPrint("Tracking local objects \(self.insertedObjects) \(self.deletedObjectIds)")
    }
    
    @objc func refresh() {
        let query = CKQuery(recordType: Event.recordType, predicate: NSPredicate(value: true))
        
        database.perform(query, inZoneWith: nil) { records, error in
            guard let records = records, error == nil else {
                self.handle(error: error!)
                return
            }
            
            self.records = records
            self.updateEvents()
            }
    }
    
}

class EventsTableViewController: UITableViewController {
    
    var model = EventsModel()
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model.onError = { error in
            let alert = UIAlertController(title: "Error", message: String(describing: error), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
            self.refreshControl!.endRefreshing()
        }
        
        self.model.onChange = {
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self.model, action: #selector(EventsModel.refresh), for: .valueChanged)
        self.refreshControl = refreshControl
        
        self.model.refresh()
    }
    
    // MARK: - Actions
    
    
    @IBAction func addEvent(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add Event", message: "", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let name = alertController.textFields!.first!.text!
            if name.count > 0 {
                self.model.addEvent(name: name)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Protocol UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        let event = model.events[indexPath.row]
        cell.textLabel?.text = event.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.model.delete(at: indexPath.row)
        }
    }
    
}
    
    
    

