//
//  MapScreen.swift
//  mapKitPlayAround
//
//  Created by Luke Dillon on 9/19/18.
//  Copyright © 2018 Luke Dillon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//class MapScreen: UIViewController {
    
  /*  @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        checkLocationServices()
    }
    
    func setupLocationManager(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            //setup location manager
            setupLocationManager()
            checkLocationAuthorization()
        }
        else {
            //alert user that something went wrong
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            //mapView.showsUserLocation = true    //could be removed if I goto mapview->show attributes->click on user location
            //do map stuff
            break
        case .denied:
            //show alert instructing them how to turn on permissions
            break
        case . notDetermined:
            locationManager.requestWhenInUseAuthorization()
            //ask permission
        case .restricted:
            //show an alert telling them what is up
            break
        case .authorizedAlways:
            break
        }
    }
}

extension MapScreen: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}*/
