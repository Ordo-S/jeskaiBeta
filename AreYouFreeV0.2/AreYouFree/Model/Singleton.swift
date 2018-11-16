//
//  Singleton.swift
//  AreYouFree
//
//  Created by Mark Casapao on 11/15/18.
//  Copyright © 2018 SJSU CMPE137. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class Singleton {
    static let shared = Singleton()
    
    private let defaultUsername = "NewUser"
    
    var currentUsername: String {
        get {
            let user = Auth.auth().currentUser
            if let user = user {
                return user.displayName ?? defaultUsername
            } else {
                return defaultUsername
            }
        }
    }
    
    private init(){
        //Do nothing for now. We need this private so that we can only refer to the shared singleton.
    }
}
