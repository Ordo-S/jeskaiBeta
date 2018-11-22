//
//  ViewController.swift
//  areYouFreev2
//
//  Created by Matt Spadaro on 11/7/18.
//  Copyright © 2018 Group 1. All rights reserved.
//

import UIKit
import os.log
import FirebaseDatabase
import FirebaseStorage

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    //Properties of View
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `EventTableViewContoller` in `prepare(for:sender:)`
     or constructed as part of adding a new event
     Tanken from apples docs.
     */
    var Event: event?
    var databaseHandle:DatabaseHandle?
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let currentUserID = Singleton.shared.currentUserID
        ref = Database.database().reference()
        
        
        // Handle the text field’s user input through delegate callbacks.
        eventTextField.delegate = self
    }
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        eventNameLabel.text = textField.text
    }
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    //MARK: Navigation
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = eventTextField.text ?? ""
        let photo = photoImageView.image
        let currentUserID = Singleton.shared.currentUserID
        
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        Event = event(name: name, photo: photo!)
        
        let eventPhoto: UIImage = photo!
        let imageData : Data = (eventPhoto.jpegData(compressionQuality: 0.8))!      // compressing image data
        let storageRef = Storage.storage().reference()                              // creating a storage reference
        
        // store image to a folder called userID/EventImages and save the image name as the event name
        storageRef.child(currentUserID + "/EventImages/" + (Event?.name)!).putData(imageData, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                return
            }
            let size = metadata.size
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return
                }
            }
        }
        
        ref.child(currentUserID + "/Events").child(Event!.name).setValue(Event!.name)   // store name of event to the database
    }
    
    //Actions of View
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        eventTextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}

