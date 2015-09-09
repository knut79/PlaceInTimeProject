//
//  LoginViewController.swift
//  PlaceInTime
//
//  Created by knut on 06/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

class LoginViewController:UIViewController,FBSDKLoginButtonDelegate, CheckViewProtocol {
    
    var passingLevelLow:Int!
    var passingLevelHigh:Int!
    var passingTags:[String] = []
    
    var usersToChallenge:[String] = []
    var userId:String!
    var userName:String!
    
    var checkitemScrollView:CheckScrollView!
    
    var tempToPlayButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            //self.performSegueWithIdentifier("segueFromLoginToPlay", sender: nil)
            
            initUserData()
            initUserFriends()
            

            

            /*
            var fbRequestFriends: FBRequest = FBRequest.requestForMyFriends()
            
            fbRequestFriends.startWithCompletionHandler{
                (connection:FBRequestConnection!,result:AnyObject?, error:NSError!) -> Void in
                
                if error == nil && result != nil {
                    println("Request Friends result : \(result!)")
                } else {
                    println("Error \(error)") 
                }
            }
            */

        }
        else
        {
            var loginButton: FBSDKLoginButton = FBSDKLoginButton()
            // Optional: Place the button in the center of your view.
            loginButton.center = self.view.center
            loginButton.readPermissions = ["public_profile", "user_friends"]
            self.view.addSubview(loginButton)
        }
    }
    
    var listClosed = true
    func closeCheckView()
    {
        if listClosed
        {
            return
        }
        
        if self.usersToChallenge.count < 3
        {
            var numberPrompt = UIAlertController(title: "Pick 3",
                message: "Select at least 3 tags",
                preferredStyle: .Alert)
            
            var numberTextField: UITextField?
            
            numberPrompt.addAction(UIAlertAction(title: "Ok",
                style: .Default,
                handler: { (action) -> Void in
                    
            }))
            
            
            self.presentViewController(numberPrompt,
                animated: true,
                completion: nil)
        }
        else
        {
            
            let rightLocation = checkitemScrollView.center
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.checkitemScrollView.transform = CGAffineTransformScale(self.checkitemScrollView.transform, 0.1, 0.1)
                
                }, completion: { (value: Bool) in
                    self.checkitemScrollView.transform = CGAffineTransformScale(self.checkitemScrollView.transform, 0.1, 0.1)
                    self.checkitemScrollView.alpha = 0
                    self.checkitemScrollView.center = rightLocation
                    self.listClosed = true

            })
        }
    }
    
    func reloadMarks(tags:[String])
    {
       self.usersToChallenge = tags
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("user_friends")
            {
                // Do work
                //self.performSegueWithIdentifier("segueFromLoginToPlay", sender: nil)
            }
        }
    }
    
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        
    }
    
    func initUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : String = result.valueForKey("name") as! String
                println("User Name is: \(userName)")
                self.userName = userName
                let userId2 = result.valueForKey("id") as! String
                println("UserId2 is: \(userId2)")
                self.userId = userId2
                 
                result
            }
        })
    }
    
    func initUserFriends()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
                
            }
            else
            {
                println("fetched friends result: \(result)")

                var friendObjects = result.valueForKey("data") as! [NSDictionary]
                /*
                for friendObject in friendObjects {
                    let name = friendObject.valueForKey("name") as! String
                    let id = friendObject.valueForKey("id")
                    println("\(name)")
                    println("\(id!)")
                }
                */
                
                var initialValues:[String:String] = [:]
                for friendObject in friendObjects {
                    initialValues.updateValue(friendObject.valueForKey("id") as! String, forKey: friendObject.valueForKey("name") as! String )
                }
                
                var scrollViewWidth = UIScreen.mainScreen().bounds.size.width * 0.6
                self.checkitemScrollView = CheckScrollView(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (scrollViewWidth / 2) , UIScreen.mainScreen().bounds.size.height / 4, scrollViewWidth, UIScreen.mainScreen().bounds.size.height / 2), initialValues: initialValues,itemsChecked:false)
                
                self.checkitemScrollView.delegate = self
                self.checkitemScrollView.alpha = 1
                self.view.addSubview(self.checkitemScrollView)
                
                
                self.tempToPlayButton = UIButton(frame:CGRectMake(0, 0, 200, 40))
                self.tempToPlayButton.addTarget(self, action: "playAction", forControlEvents: UIControlEvents.TouchUpInside)
                self.tempToPlayButton.backgroundColor = UIColor.blueColor()
                self.tempToPlayButton.layer.cornerRadius = 5
                self.tempToPlayButton.layer.masksToBounds = true
                self.tempToPlayButton.setTitle("Play", forState: UIControlState.Normal)
                
                self.view.addSubview(self.tempToPlayButton)
                
                result
            }
        })
    }
    
    
    func playAction()
    {
        self.performSegueWithIdentifier("segueFromLoginToPlay", sender: nil)
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueFromLoginToPlay") {
            var svc = segue!.destinationViewController as! PlayViewController
            svc.levelLow = passingLevelLow
            svc.levelHigh = passingLevelHigh
            svc.tags = passingTags
            svc.gametype = gameType.challenge
            svc.usersIdsToChallenge = self.usersToChallenge
            svc.myIdAndName = (self.userId,self.userName)
        }
    }
}