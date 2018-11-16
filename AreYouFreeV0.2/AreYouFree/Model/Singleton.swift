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
    
    private let defaultUsername = "Missing Username"
    private let defaultUserID = "ID_Doesn't_Exist"
    private let defaultEmail = "Missing Email"
    
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
    
    var currentUserID: String {
        get {
            let user = Auth.auth().currentUser
            if let user = user {
                return user.uid
            } else {
                return defaultUserID
            }
        }
    }
    
    var currentUserEmail: String {
        get {
            let user = Auth.auth().currentUser
            if let user = user {
                return user.email ?? defaultEmail
            } else {
                return defaultEmail
            }
        }
    }
    
    private init(){
        //Do nothing for now. We need this private so that we can only refer to the shared singleton.
    }
}
