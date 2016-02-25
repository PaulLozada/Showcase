//
//  DataCell.swift
//  Showcase
//
//  Created by Paul Lozada on 2016-02-22.
//  Copyright © 2016 Paul Lozada. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class DataCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLbl : UILabel!
    @IBOutlet weak var likesImage : UIImageView!
    
    var post : Post!
    var request : Request?
    var likeRef : Firebase!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likesImage.addGestureRecognizer(tap)
        likesImage.userInteractionEnabled = true
        // Initialization code
    }

    override func drawRect(rect: CGRect) {
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
}
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(post: Post, image: UIImage?) {
        
        self.post = post
        likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        self.descriptionText.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        
        if post.imageUrl != nil {
            if image != nil {
                self.showcaseImg.image = image
            } else {
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    
                    if err == nil{
                        let img = UIImage(data: data!)!
                        self.showcaseImg.image = img
                        FeedViewController.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    }
                })
            }
        } else {
            self.showcaseImg.hidden = true
        }
        
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let doesNotExist = snapshot.value as? NSNull {
                // We have not liked this POST.
                self.likesImage.image = UIImage(named: "heart-empty")
            } else {
                self.likesImage.image = UIImage(named: "heart-full")
            }
        })
    }
    
    func likeTapped(sender:UITapGestureRecognizer){
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if let doesNotExist = snapshot.value as? NSNull {
                // We have not liked this POST.
                self.likesImage.image = UIImage(named: "heart-full")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)
            } else {
                self.likesImage.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(false)
                self.likeRef.removeValue( )
            }
        })
        
    }
}
