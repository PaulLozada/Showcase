//
//  DataCell.swift
//  Showcase
//
//  Created by Paul Lozada on 2016-02-22.
//  Copyright © 2016 Paul Lozada. All rights reserved.
//

import UIKit
import Alamofire


class DataCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLbl : UILabel!
    
    var post : Post!
    var request : Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
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
        
    
    }
}
