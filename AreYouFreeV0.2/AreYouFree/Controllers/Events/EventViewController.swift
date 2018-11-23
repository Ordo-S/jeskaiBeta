//
//  ViewController.swift
//  areYouFreev2
//
//  Created by Matt Spadaro on 11/7/18.
//  Copyright © 2018 Group 1. All rights reserved.
//

import UIKit
import os.log
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    //Properties of View
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventAdressLabel: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `EventTableViewContoller` in `prepare(for:sender:)`
     or constructed as part of adding a new event
     Tanken from apples docs.
     */
    var Event: event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Handle the text field’s user input through delegate callbacks.
        eventTextField.delegate = self
        eventAdressLabel.delegate = self
        
        // Set up views if editing an existing Event.
        if let event = Event {
            navigationItem.title = event.name
            eventTextField.text = event.name
            photoImageView.image = event.photo
            eventAdressLabel.text = event.address
        }
        
        setUpUI()
    }
    
    private func setUpUI() {
        self.hideKeyboardWhenTappedAround()
        
        let cornerRad = CGFloat(25)
        let borderWidth = CGFloat(1)
        let borderColor = UIColor.gray.cgColor
        
        eventTextField.layer.cornerRadius = cornerRad
        eventTextField.layer.borderWidth = borderWidth
        eventTextField.layer.borderColor = borderColor
        eventTextField.clipsToBounds = true
        eventTextField.keyboardType = .default
        
        eventAdressLabel.layer.cornerRadius = cornerRad
        eventAdressLabel.layer.borderWidth = borderWidth
        eventAdressLabel.layer.borderColor = borderColor
        eventAdressLabel.clipsToBounds = true
        eventAdressLabel.keyboardType = .default
    }
    
    
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == eventTextField) {
            if textField.text?.count != 0 {
                eventNameLabel.text = textField.text
            } else {
                eventNameLabel.text = "Event"
            }
        }
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
    @IBAction func cancelButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToEvents", sender: self)
    }
    
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
        let address = eventAdressLabel.text ?? ""
        
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        Event = event(name: name, photo: photo!, address: address)
       
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
   
    //Orientation lock purposes
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
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

