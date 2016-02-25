//
//  ViewController.swift
//  Showcase
//
//  Created by Paul Lozada on 2016-02-20.
//  Copyright © 2016 Paul Lozada. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: self)
        }
    }
    
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var emailField : UITextField!
    @IBOutlet weak var passwordField: UITextField!

    //MARK: IBActions
    
    @IBAction func fbButtongPressed(sender:UIButton!){
        
        let facebookLogin = FBSDKLoginManager( )
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged in with facebook \(accessToken)")
                
                DataService.ds.REF_Base.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { (error, authData) in
                    
                    if error != nil {
                        print("Login failed. \(error)")
                    } else {
                        
                        let user = ["provider":authData.provider!, "blah":"test"]
                        DataService.ds.createFirebaseUser(authData.uid, user: user)
                        
                        print("Logged In! \(authData)")
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        
                        
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: self)
                    }
                    
                })
                
            }
        }
    }
    
    @IBAction func attemptLogin(sender:UIButton!) {
        
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            DataService.ds.REF_Base.authUser(email, password: pwd, withCompletionBlock: { (error, authData) in
                
                if error != nil {
                    print(error)
                    
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        DataService.ds.REF_Base.createUser(email, password: pwd, withValueCompletionBlock: { (error, result) in
                            if error != nil {
                                self.showErrorAlert("Could not create account", message: "Problem creating account. Try something else")
                            } else {
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                
                                DataService.ds.REF_Base.authUser(email, password: pwd, withCompletionBlock: { err, authData in
                                    
                                    let user = ["provider":authData.provider!, "blah":"emailtest"]
                                    DataService.ds.createFirebaseUser(authData.uid, user: user)
                                })
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            }
                        })
                    } else {
                        self.showErrorAlert("Could not login", message: "Please check username and password")
                    }
                } else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })
        } else {
            showErrorAlert("Email and Password Required", message: "You must enter an email and password")
        }
    }
    
    func showErrorAlert(title:String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

