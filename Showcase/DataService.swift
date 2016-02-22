//
//  DataService.swift
//  Showcase
//
//  Created by Paul Lozada on 2016-02-22.
//  Copyright © 2016 Paul Lozada. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let ds = DataService( )
    
    private var _REF_Base = Firebase(url: "https://appshowcase1.firebaseio.com")
    
    var REF_Base : Firebase {
        return _REF_Base
    }
}