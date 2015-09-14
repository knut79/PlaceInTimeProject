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

class ChallengeViewController:UIViewController,FBSDKLoginButtonDelegate, UserViewProtocol {
    
    var passingLevelLow:Int!
    var passingLevelHigh:Int!
    var passingTags:[String] = []
    
    var usersToChallenge:[String] = []
    var userId:String!
    var userName:String!
    
    var usersToChallengeScrollView:UserScrollView!
    var gametype:gameType!
    
    var playButton:UIButton!
    var addRandomUserButton:UIButton!
    var titleLabel:UILabel!
    
    var client: MSClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.client = (UIApplication.sharedApplication().delegate as! AppDelegate).client
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            //self.performSegueWithIdentifier("segueFromLoginToPlay", sender: nil)
            
            initUserData()
            if self.gametype == gameType.makingChallenge
            {
                self.initUserFriends()
            }
            else if self.gametype == gameType.takingChallenge
            {
                
            }
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
    
    override func viewDidLayoutSubviews() {

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
                initUserData()
                if self.gametype == gameType.makingChallenge
                {
                    self.initUserFriends()
                }

                
                
            }
            else
            {
                //TODO show logout button and message telling that friends list must be premitted to continue
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
                
                if self.gametype == gameType.takingChallenge
                {
                    self.initChallenges()
                }
                
                
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

                self.initForNewChallenge(friendObjects)
                
                
                
                result
            }
        })
    }
    
    func initForNewChallenge(friendObjects:[NSDictionary])
    {
        var initialValues:[String:String] = [:]
        for friendObject in friendObjects {
            initialValues.updateValue(friendObject.valueForKey("id") as! String, forKey: friendObject.valueForKey("name") as! String )
        }

        
        let margin:CGFloat = 10
        let elementWidth:CGFloat = 200
        let elementHeight:CGFloat = 40
        titleLabel = UILabel(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (elementWidth / 2), margin, elementWidth, elementHeight))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = "Challenge users"
        view.addSubview(titleLabel)
        
        
        
        
        self.playButton = UIButton(frame:CGRectMake(titleLabel.frame.minX, UIScreen.mainScreen().bounds.size.height - margin - elementHeight, elementWidth , elementHeight))
        self.playButton.addTarget(self, action: "playAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.playButton.backgroundColor = UIColor.blueColor()
        self.playButton.layer.cornerRadius = 5
        self.playButton.layer.masksToBounds = true
        self.playButton.setTitle("Play", forState: UIControlState.Normal)
        self.view.addSubview(self.playButton)
        
        addRandomUserButton = UIButton(frame:CGRectMake(titleLabel.frame.minX, playButton.frame.minY - margin - elementHeight, elementWidth , elementHeight))
        self.addRandomUserButton.addTarget(self, action: "addRandomUserAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.addRandomUserButton.backgroundColor = UIColor.blueColor()
        self.addRandomUserButton.layer.cornerRadius = 5
        self.addRandomUserButton.layer.masksToBounds = true
        self.addRandomUserButton.setTitle("Add random user", forState: UIControlState.Normal)
        self.view.addSubview(self.addRandomUserButton)
        
        let scrollViewHeight =  addRandomUserButton.frame.minY - titleLabel.frame.maxY - ( margin * 2 )
        var scrollViewWidth = UIScreen.mainScreen().bounds.size.width - (margin * 2)

        let values:[String:String] = ["#war":"#war","#headOfState":"#headOfState","#science":"#science","#discovery":"#discovery","#invention":"#invention","#sport":"#sport","#miscellaneous":"#miscellaneous"]
        
        self.usersToChallengeScrollView = UserScrollView(frame: CGRectMake(margin , titleLabel.frame.maxY + margin, scrollViewWidth, scrollViewHeight),initialValues:values, itemsChecked:false)
        self.usersToChallengeScrollView.delegate = self
        self.usersToChallengeScrollView.alpha = 1
        self.view.addSubview(self.usersToChallengeScrollView)


    }

    
    
    func initChallenges()
    {
        var jsonDictionary = ["fbid":userId,"name":userName]
        self.client!.invokeAPI("challenge", data: nil, HTTPMethod: "GET", parameters: jsonDictionary, headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                println("\(error)")
            }
            if result != nil
            {
                //Note ! root json object is not a dictionary but an array
                
                var e: NSError?
                var jsonArray = NSJSONSerialization.JSONObjectWithData(result, options: NSJSONReadingOptions.MutableContainers, error: &e) as? NSArray
                
                if let array = jsonArray {
                    for item in array {
                        println("item : \(item)")
                    }
                    
                } else {
                    println("\(e)")
                }

                
                /*
                var error: NSError?
                if let JSONData = result { // Check 1
                    if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(JSONData, options: nil, error: &error) { // Check 2
                        if let jsonDictionary = json as? NSDictionary { // Check 3
                            println("Dictionary received")
                        }
                        else {
                            if let jsonString = NSString(data: JSONData, encoding: NSUTF8StringEncoding) {
                                println("JSON String: \n\n \(jsonString)")
                            }
                            fatalError("JSON does not contain a dictionary \(json)")
                        }
                    }
                    else {
                        fatalError("Can't parse JSON \(error)")
                    }
                }
                else {
                    fatalError("JSONData is nil")
                }
                */
                
                

                let json = JSON(result!)
                /*
                if let appName = json["feed"]["entry"][0]["im:name"]["label"].string {
                    println("SwiftyJSON: \(appName)")
                }
                */

                
                let test2 = json[0][0]
                println("test2 \(test2)")

            }
            if response != nil
            {
                println("\(response)")
                let json = JSON(result)
                println("\(json)")
            }
        })
    }
    
    func addRandomUserAction()
    {
        addRandomUserButton.alpha = 0
        self.usersToChallengeScrollView.addItem("julia test", value: "123456")
    }
    
    func playAction()
    {
        if self.gametype == gameType.makingChallenge
        {
            usersToChallenge = self.usersToChallengeScrollView.getItemsValueAsArray()
            
            if usersToChallenge.count < 1
            {
            var numberPrompt = UIAlertController(title: "Pick 1",
                message: "Select at least 1 user",
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
                self.performSegueWithIdentifier("segueFromChallengeToPlay", sender: nil)
            }
        }
        
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueFromChallengeToPlay") {
            var svc = segue!.destinationViewController as! PlayViewController
            svc.levelLow = passingLevelLow
            svc.levelHigh = passingLevelHigh
            svc.tags = passingTags
            svc.gametype = gametype
            if self.gametype == gameType.makingChallenge
            {
                svc.usersIdsToChallenge = self.usersToChallenge
            }
            
            svc.myIdAndName = (self.userId,self.userName)
        }
    }
}