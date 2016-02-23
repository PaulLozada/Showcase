//
//  DataService.swift
//  Showcase
//
//  Created by Paul Lozada on 2016-02-22.
//  Copyright © 2016 Paul Lozada. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://appshowcase1.firebaseio.com/"

class DataService {
    static let ds = DataService( )
    
    private var _REF_Base = Firebase(url: "\(URL_BASE)")
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    var REF_Base : Firebase {
        return _REF_Base
    }
    
    var REF_POSTS : Firebase {
        return _REF_POSTS
    }
    
    var REF_USERS : Firebase {
        return _REF_USERS
    }
    
    func createFirebaseUser(uid:String, user: [String:String]){
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
}