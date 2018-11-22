//
//  EventDetailViewController.swift
//  
//
//  Created by Matt Spadaro on 11/21/18.
//

import UIKit

class EventDetailViewController: UIViewController, UINavigationControllerDelegate {
    //Mark: Properties
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventAdressLabel: UILabel!
    @IBOutlet weak var eventPhotoImage: UIImageView!
    
    // Declare as var for mutability and initialize as nil.
    var event: event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the View
       
        if let event = event {
            navigationItem.title = event.name
            eventNameLabel.text = event.name
            eventPhotoImage.image = event.photo
            eventAdressLabel.text = event.address
        }
    }
    
    

}
