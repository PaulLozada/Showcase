//
//  FeedViewController.swift
//  Showcase
//
//  Created by Paul Lozada on 2016-02-22.
//  Copyright © 2016 Paul Lozada. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class FeedViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var posts = [Post]( )
    var imageSelected = false
    var imagePicker = UIImagePickerController( )
    static var imageCache = NSCache( )
    
    
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var postField: UITextField!
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    
    @IBAction func makePost(sender: UIButton) {
        
        if let txt = postField.text where txt != "" {
            if let img = imageSelectorImage.image where imageSelected == true {
                let urlSting = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlSting)!
                let imageData = UIImageJPEGRepresentation(img, 0.2)!
                let keyData = "267DGMQTae476eb0db1f46e86a128d3c87ac095f".dataUsingEncoding(NSUTF8StringEncoding)!
                let keyJson = "json".dataUsingEncoding(NSUTF8StringEncoding)!
                
                Alamofire.upload(.POST, url, multipartFormData: { multipartFormData in
                    
                    multipartFormData.appendBodyPart(data: imageData, name: "fileupload", fileName: self.postField.text!, mimeType: "image/jpg")
                    multipartFormData.appendBodyPart(data: keyData, name: "key")
                    multipartFormData.appendBodyPart(data: keyJson, name: "format")
                    
                    })
                        { encodingResult in
                    
                    switch encodingResult {
                    case .Success(let upload , _ , _ ) :
                        upload.responseJSON(completionHandler: { response  in
                            if let info = response.result.value as? [String:AnyObject] {
                                if let links = info["links"] as? [String:AnyObject] {
                                    if let imgLink = links["image_link"] as? String {
                                        print("LINK \(imgLink)")
                                        
                                    self.postToFireBase(imgLink)
                                    }
                                }
                            }
                        })
                        
                    case .Failure(let error) :
                        print(error)
                    }
                    
                }
            } else {
                postToFireBase(nil)
            }
            
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageSelectorImage.image = image
        imageSelected = true
    
        
    }
    
    @IBAction func passed(sender: UITapGestureRecognizer) {
        
          presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? DataCell {
            
            cell.request?.cancel()
            
            var img: UIImage?
            
            if let url = post.imageUrl {
                img = FeedViewController.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post,image: img)
            return cell
        } else {
            return DataCell( )
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            
            self.posts = [ ]
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                for snap in snapshots{
                    print("SNAP :\(snap)")
                    
                    if let postDict = snap.value as? [String: AnyObject] {
                        let key = snap.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func postToFireBase(imgUrl : String?)  {
        var post :[String:AnyObject] = [
            "description":postField.text!,
            "likes" : 0
        ]
        
        if imgUrl != nil{
            post["imageUrl"] = imgUrl!
        }
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId( )
        firebasePost.setValue(post)
        postField.text = ""
        imageSelectorImage.image = UIImage(named: "Camera")
        imageSelected = false
        
        tableView.reloadData()
    }
}
