//
//  HomepageViewController.swift
//  AreYouFree
//
//  Created by Mark Casapao on 10/20/18.
//  Copyright © 2018 SJSU CMPE137. All rights reserved.
//

import UIKit

class HomepageViewController: UIViewController {

    @IBOutlet var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        signOutButton.layer.cornerRadius = CGFloat(25)
    }
    
    @IBAction func signOutClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    

    /*
    // MARK: - Navigation
b
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
