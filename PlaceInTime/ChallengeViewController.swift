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
    var challengeScrollView:ChallengeScrollView!
    var gametype:gameType!
    
    var playButton:UIButton!
    var backButton = UIButton()
    var activityLabel:UILabel!
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
                //self.userId = "1492605914370841"
                //self.userId = "10155943015600858"
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
    
    func initCommonElements(margin:CGFloat,elementWidth:CGFloat,elementHeight:CGFloat)
    {
        titleLabel = UILabel(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (elementWidth / 2), margin, elementWidth, elementHeight))
        titleLabel.textAlignment = NSTextAlignment.Center
        
        
        self.playButton = UIButton(frame:CGRectMake(titleLabel.frame.minX, UIScreen.mainScreen().bounds.size.height - margin - elementHeight, elementWidth , elementHeight))
        self.playButton.addTarget(self, action: "playAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.playButton.backgroundColor = UIColor.blueColor()
        self.playButton.layer.cornerRadius = 5
        self.playButton.layer.masksToBounds = true
        self.playButton.setTitle("Play", forState: UIControlState.Normal)
        
        
        activityLabel = UILabel(frame: CGRectMake(0, 0, 400, 50))
        activityLabel.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        activityLabel.textAlignment = NSTextAlignment.Center

        

        let backButtonMargin:CGFloat = 15
        backButton.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width - smallButtonSide - backButtonMargin, backButtonMargin, smallButtonSide, smallButtonSide)
        backButton.backgroundColor = UIColor.whiteColor()
        backButton.layer.borderColor = UIColor.grayColor().CGColor
        backButton.layer.borderWidth = 1
        backButton.layer.cornerRadius = 5
        backButton.layer.masksToBounds = true
        backButton.setTitle("🔙", forState: UIControlState.Normal)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        
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

        self.initCommonElements(margin,elementWidth: elementWidth,elementHeight: elementHeight)
        
        titleLabel.text = "Challenge users"
        
        
        
        addRandomUserButton = UIButton(frame:CGRectMake(titleLabel.frame.minX, playButton.frame.minY - margin - elementHeight, elementWidth , elementHeight))
        self.addRandomUserButton.addTarget(self, action: "addRandomUserAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.addRandomUserButton.backgroundColor = UIColor.blueColor()
        self.addRandomUserButton.layer.cornerRadius = 5
        self.addRandomUserButton.layer.masksToBounds = true
        self.addRandomUserButton.setTitle("Add random user", forState: UIControlState.Normal)

        
        let scrollViewHeight =  addRandomUserButton.frame.minY - titleLabel.frame.maxY - ( margin * 2 )
        var scrollViewWidth = UIScreen.mainScreen().bounds.size.width - (margin * 2)
        self.usersToChallengeScrollView = UserScrollView(frame: CGRectMake(margin , titleLabel.frame.maxY + margin, scrollViewWidth, scrollViewHeight),initialValues:initialValues, itemsChecked:false)
        self.usersToChallengeScrollView.delegate = self
        self.usersToChallengeScrollView.alpha = 1
        
        view.addSubview(titleLabel)
        view.addSubview(playButton)
        view.addSubview(backButton)
        view.addSubview(addRandomUserButton)
        view.addSubview(usersToChallengeScrollView)
        view.addSubview(activityLabel)
        
        if friendObjects.count == 0
        {
            
            addRandomUser( { () in
                self.activityLabel.alpha = 1
                self.activityLabel.text = "No facebook friends with this app😢"
            })
        }
        else
        {
            activityLabel.alpha = 0
        }
        
        
    }
    
    
    func initChallenges()
    {
        
        let margin:CGFloat = 10
        let elementWidth:CGFloat = 200
        let elementHeight:CGFloat = 40

        self.initCommonElements(margin,elementWidth: elementWidth,elementHeight: elementHeight)
        
        titleLabel.text = "Pick a challenge"
        activityLabel.text = "Collecting challenges..."

        let scrollViewHeight =  playButton.frame.minY - titleLabel.frame.maxY - ( margin * 2 )
        var scrollViewWidth = UIScreen.mainScreen().bounds.size.width - (margin * 2)
        self.challengeScrollView = ChallengeScrollView(frame: CGRectMake(margin , titleLabel.frame.maxY + margin, scrollViewWidth, scrollViewHeight), itemsChecked:false)
        //self.challengeScrollView.delegate = self
        self.challengeScrollView.alpha = 1
        
        view.addSubview(titleLabel)
        view.addSubview(playButton)
        view.addSubview(backButton)
        view.addSubview(challengeScrollView)
        view.addSubview(activityLabel)
        
        var jsonDictionary = ["fbid":userId,"name":userName]
        //var jsonDictionary = ["fbid":"10155943015600858","name":userName]
        
        self.client!.invokeAPI("challenge", data: nil, HTTPMethod: "GET", parameters: jsonDictionary, headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                self.activityLabel.text = "\(error)"
            }
            if result != nil
            {
                //Note ! root json object is not a dictionary but an array
                
                var e: NSError?
                var jsonArray = NSJSONSerialization.JSONObjectWithData(result, options: NSJSONReadingOptions.MutableContainers, error: &e) as? NSArray
                
                if let array = jsonArray
                {
                    for item in array {
                        println("item : \(item)")
                        if let jsonDictionary = item as? NSDictionary {
                            let title = jsonDictionary["title"] as! String
                            self.challengeScrollView.addItem(title,value: jsonDictionary)
                            
                            self.activityLabel.alpha = 0
                        }
                    }
                    if jsonArray?.count == 0
                    {
                        self.activityLabel.text = "No pending challenges from other users😒"
                    }
                    
                } else {
                    self.activityLabel.text = "\(e)"
                }

                
                /*
                challengeId = "b1e050dc-e28f-47d9-a7a8-4fb9bbe4a3c0";
                correctAnswersToBeat = 2;
                fbIdToBeat = 1492605914370841;
                pointsToBeat = 40;
                questionsStringFormat = "187,55,49;240,22,30;136,239,139";
                title = "(1492605914370841, Temp Tempesen) 1-2 )";
                */
                
                /*
                var error: NSError?
                if let JSONData = result { // Check 1
                    if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(JSONData, options: nil, error: &error) { // Check 2
                        
                        if let array = json as? NSArray
                        {
                                for item in array {
                                    println("item : \(item)")
                                    if let jsonDictionary = item as? NSDictionary { // Check 3
                                        println("\(jsonDictionary[0])")
                                    }
                                }
                        }
                        
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

                /*
                if let appName = json["feed"]["entry"][0]["im:name"]["label"].string {
                    println("SwiftyJSON: \(appName)")
                }
                */


            }
            if response != nil
            {
                println("\(response)")
            }
            
        })
    }
    
    
    
    var randomUsersAdded = 0
    func addRandomUserAction()
    {
        activityLabel.alpha = 1
        activityLabel.text = "Collecting random user..."
        addRandomUser(nil)
    }
    
    func addRandomUser(completionClosure: (() -> Void)? )
    {

        randomUsersAdded++
        if randomUsersAdded > 2
        {
            activityLabel.alpha = 0
            addRandomUserButton.alpha = 0
        }
        let userUsed:String = usersToChallengeScrollView.getAllItemsValueAsStringFormat()
        
        var jsonDictionary = ["fbid":userId,"name":userName,"usedusers":userUsed]
        
        self.client!.invokeAPI("randomuser", data: nil, HTTPMethod: "GET", parameters: jsonDictionary, headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                println("\(error)")
            }
            if result != nil
            {
                //Note ! root json object is not a dictionary but an array
                
                var e: NSError?
                if let json: AnyObject = NSJSONSerialization.JSONObjectWithData(result, options: nil, error: &e)
                {
                    if let jsonDictionary = json as? NSDictionary { // Check 3
                        println("Dictionary received")
                        let name = jsonDictionary["name"] as! String
                        let fbId = jsonDictionary["fbid"] as! String
                        self.usersToChallengeScrollView.addItem("\(name) (random user)", value: fbId)
                    }
                }
                
            }
            if response != nil
            {
                println("\(response)")
            }
            self.activityLabel.alpha = 0
            completionClosure?()
        })
        
    }
    
    func playAction()
    {
        if self.gametype == gameType.makingChallenge
        {
            usersToChallenge = self.usersToChallengeScrollView.getCheckedItemsValueAsArray()
            
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
        else if self.gametype == gameType.takingChallenge
        {
            self.performSegueWithIdentifier("segueFromChallengeToPlay", sender: nil)
        }
        
    }
    
    func backAction()
    {
        self.performSegueWithIdentifier("segueFromChallengeToMainMenu", sender: nil)
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
            else if self.gametype == gameType.takingChallenge
            {
                var values = self.challengeScrollView.getSelectedValue()
                svc.challenge = Challenge(values: values!)
            }
            
            svc.myIdAndName = (self.userId,self.userName)
        }
    }
}