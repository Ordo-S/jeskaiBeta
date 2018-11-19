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
    func calculateLat() -> Double
    func calculateLon() -> Double
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

extension event: findLocationProtocal {
    func calculateLat() -> Double {
        var lat: Double?
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            placemarks, error in
            let placemark = placemarks?.first
            lat = placemark?.location?.coordinate.latitude
            //print("Lat: \(String(describing: self.lat)), Lon: \(String(describing: self.lon))")
        }
        return lat ?? 37.333944
    }
    
     func calculateLon() -> Double{
        var lon: Double?
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            placemarks, error in
            let placemark = placemarks?.first
            lon = placemark?.location?.coordinate.latitude
        }
        return lon ??  -121.883991
    }
    }
    


