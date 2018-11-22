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
    var Event: event?
    // To know whether or not we have deleted the contact.
    var indexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the View
        eventNameLabel.text = Event?.name
        eventAdressLabel.text = Event?.address
        eventPhotoImage.image = Event?.photo
    }
    
    

}
