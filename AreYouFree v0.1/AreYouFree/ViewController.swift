//
//  ViewController.swift
//  AreYouFree
//
//  Created by Mark Casapao on 9/20/18.
//  Copyright © 2018 SJSU CMPE137. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ref = Database.database().reference()
        databaseHandle = ref.child("Test").observe(DataEventType.value, with: { (snapshot) in
            if let post = snapshot.value as? String {
                self.label.text = post
            } else {
                self.label.text = "Database value not found."
            }
        })
    }
    
    func updateViewFromModel() {
        
    }
    
    @IBAction func submit(_ sender: Any) {
        self.ref.child("Test").setValue(textField.text)
    }
    
}

