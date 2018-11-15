//
//  event.swift
//  areYouFreev2
//
//  Created by Matt Spadaro on 11/7/18.
//  Copyright © 2018 Group 1. All rights reserved.
//

import UIKit

class event{
    //MARK: Properties
    var name: String
    var photo: UIImage?
    //Mark: Inits
    // Initialization should fail if there is no name.
    init?(name:String, photo:UIImage) {
        // Initialize stored properties.
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        
    }
}

