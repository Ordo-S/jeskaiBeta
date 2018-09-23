//
//  ViewController.swift
//  project group 1
//
//  Created by Ordo on 9/21/18.
//  Copyright © 2018 Group1. All rights reserved.
//
import CloudKit
import UIKit

private func fetchUserRecordID() {
    // Fetch Default Container
    let defaultContainer = CKContainer.default()
    
    // Fetch User Record
    defaultContainer.fetchUserRecordID { (recordID, error) -> Void in
        if let responseError = error {
            print(responseError)
            
        } else if let userRecordID = recordID {
            DispatchQueue.main.sync {
                fetchUserRecord(recordID: userRecordID)
            }
        }
    }
}
private func fetchUserRecord(recordID: CKRecord.ID) {
    // Fetch Default Container
    let defaultContainer = CKContainer.default()
    
    // Fetch Private Database
    let privateDatabase = defaultContainer.privateCloudDatabase
    
    // Fetch User Record
    privateDatabase.fetch(withRecordID: recordID) { (record, error) -> Void in
        if let responseError = error {
            print(responseError)
            
        } else if let userRecord = record {
            print(userRecord)
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Fetch User Record ID
        fetchUserRecordID()
    }


}

