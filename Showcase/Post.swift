//
//  Post.swift
//  Showcase
//
//  Created by Paul Lozada on 2016-02-23.
//  Copyright © 2016 Paul Lozada. All rights reserved.
//

import Foundation

class Post {
    private var _postDescription : String!
    private var _imageUrl : String?
    private var _likes : Int!
    private var _username: String!
    private var _postKey: String!
    
    var postDescription: String {
        return _postDescription
    }

    var imageUrl : String? {
        return _imageUrl
    }
    
    var likes : Int! {
        return _likes
    }
    
    var username : String {
        return _username
    }
    
    var postKey : String {
        return _postKey
    }
    
    init(description: String, imageUrl: String?, username: String){
        self._postDescription = description
        self._imageUrl = imageUrl
        self._username = username
    }
    
    init(postKey: String, dictionary: [String: AnyObject]){
        self._postKey = postKey
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        if let imgUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imgUrl
        }
        
        if let desc = dictionary["description"] as? String {
            self._postDescription = desc
        }
    }
}
