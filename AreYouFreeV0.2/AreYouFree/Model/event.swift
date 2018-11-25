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
    func getLongitute() -> Double
    func getLatitude(completion: (Bool, CLLocationCoordinate2D) -> Void)
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
    func getLongitute() -> Double {
        var coordinates: CLLocationCoordinate2D?
        var lon: Double = -118.881503
        let geocoder = CLGeocoder()
        let address = "2575 Las Palmas Way, San Jose, CA"
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                c
               // print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                lon = (coordinates?.longitude)!
                }
            })
        return (coordinates?.longitude) ?? lon
    }
    func getCordinates(completion: (Bool, CLLocationCoordinate2D) -> Void) {
        //var lat: Double = 34.202903
        let geocoder = CLGeocoder()
        let address = "2575 Las Palmas Way, San Jose, CA"
        geoCoder.geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
            if error != nil {
                print(error?.localizedDescription)
                completion(false,nil)
            } else {
                if placemarks!.count > 0 {
                    let placemark = placemarks![0] as CLPlacemark
                    let location = placemark.location
                    
                    completion(true, location?.coordinate)
                    
                }
            }
    }
    
}

    


