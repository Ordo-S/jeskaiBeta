//
//  ViewController.swift
//  areYouFreev2
//
//  Created by Matt Spadaro on 11/7/18.
//  Copyright © 2018 Group 1. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //Properties of View
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //Actions of View
    @IBAction func setDefualtLabelText(_ sender: UIButton) {
        eventNameLabel.text = "Default Text"
    }
   

}

