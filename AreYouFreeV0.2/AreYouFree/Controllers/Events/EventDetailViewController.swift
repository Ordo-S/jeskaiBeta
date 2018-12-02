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
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    // Declare as var for mutability and initialize as nil.
    var event: event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the View
        //Set the View
        if let event = event {
            navigationItem.title = event.name
            eventNameLabel.text = event.name
            eventPhotoImage.image = event.photo
            eventAdressLabel.text = event.address
        }
        setUpUI()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //From Apples docs on how to send to segue
       
        switch(segue.identifier ?? "") {
            
        case "EditEvent":
            guard let viewController = segue.destination as? ViewController else{
                fatalError("Unexpected destination: \(segue.destination)") }
            //Passing the details to the view
            viewController.Event = event
            
        case "Invite":
            //taken from apple docs exactly modifed for project use
            guard let ViewController = segue.destination as? InviteSendTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            ViewController.event = event
            
            
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    private func setUpUI() {
        let cornerRad = CGFloat(25)
        inviteButton.layer.cornerRadius = cornerRad
        editButton.layer.cornerRadius = cornerRad
    }
    
    //Orientation lock purposes
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    //Releasing orientation lock purposes
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    //Set status bar to white icons
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
