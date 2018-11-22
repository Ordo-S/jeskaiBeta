//
//  event.swift
//  areYouFreev2
//
//  Created by Matt Spadaro on 11/7/18.
//  Copyright © 2018 Group 1. All rights reserved.
//

import UIKit
import CoreLocation

protocol findLocationProtocal {
    var address:String {get}
    
}
class event{
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var address: String
   
    //Mark: Inits
    // Initialization should fail if there is no name.
    init?(name:String, photo:UIImage, address:String ) {
        // Initialize stored properties.
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        guard !address.isEmpty else {
            return nil
        }
      
        
        self.name = name
        self.photo = photo
        self.address = address
        //Mark: Testing out Map features
        //Code taken from https://stackoverflow.com/questions/42279252/convert-address-to-coordinates-swift
        //And launching Map app https://www.youtube.com/watch?v=INfCmCxLC0o
        
    }
    
}
//need to return lat and long
extension event: findLocationProtocal {
    
   
}
    


