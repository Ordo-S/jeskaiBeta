//
//  EventTableViewCell.swift
//  areYouFreev2
//
//  Created by Matt Spadaro on 11/7/18.
//  Copyright © 2018 Group 1. All rights reserved.
//

import UIKit
import MapKit

class EventTableViewCell: UITableViewCell {
    //Mark: Properties
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBAction func sendToMapsButton(_ sender: UIButton) {
        //Defining destination
        let latitude:CLLocationDegrees = 39.048825
        let longitude:CLLocationDegrees = -120.981227
        
        let regionDistance:CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "My House"
        mapItem.openInMaps(launchOptions: options)
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
