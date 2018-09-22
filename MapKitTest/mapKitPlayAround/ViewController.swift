//
//  ViewController.swift
//  mapKitPlayAround
//
//  Created by Luke Dillon on 9/19/18.
//  Copyright © 2018 Luke Dillon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // set initial location at San Jose State
        let initialLocation = CLLocation(latitude: 37.33519080000001, longitude: -121.88126008152719)
        centerMapOnLocation(location: initialLocation)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }


}

