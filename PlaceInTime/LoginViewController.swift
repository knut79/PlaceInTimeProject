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
    
    var client: MSClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.client = (UIApplication.sharedApplication().delegate as! AppDelegate).client
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            //self.performSegueWithIdentifier("segueFromLoginToPlay", sender: nil)
            
            initUserData()
            initUserFriends()
            

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
                initUserData()
                initUserFriends()
                
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
                
                
                self.initChallenges()
                
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
                println("\(result)")
                
                /*
                var err: NSError?
                var jsonResult = NSJSONSerialization.JSONObjectWithData(result, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
                if err != nil {
                    // If there is an error parsing JSON, print it to the console
                    println("JSON Error \(err!.localizedDescription)")
                }
                */
                
                let json = JSON(result)
                println("\(json)")
                if let appName = json["feed"]["entry"][0]["im:name"]["label"].string {
                    println("SwiftyJSON: \(appName)")
                }
                /*
                
                let count: Int? = json["data"].array?.count
                println("found \(count!) challenges")
                
                if let ct = count {
                    for index in 0...ct-1 {
                        // println(json["data"][index]["challengeName"].string!)
                        if let name = json["data"][index]["challengeName"].string {
                            println(name)
                        }
                        
                    }
                }
                */
                /*
                
                NSMutableString* newStr = [[NSMutableString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                
                //NSLog(@"The datastring : %@",newStr);
                
                //remove front [ and back ] characters
                if ([newStr rangeOfString: @"]"].length >0) {
                    [newStr deleteCharactersInRange: NSMakeRange([newStr length]-1, 1)];
                    [newStr deleteCharactersInRange: NSMakeRange(0,1)];
                    NSLog(@"The datastring : %@",newStr);
                }
                
                NSMutableArray* dataArray = [[NSMutableArray alloc] init];
                
                
                
                int ind = 0;
                while ([newStr rangeOfString: @"}"].length >0) {
                    NSRange match = [newStr rangeOfString: @"}"];
                    NSString* rowSubstring1 = [newStr substringWithRange:NSMakeRange(0, match.location+1)];
                    NSLog(@"The substring1 : %@",rowSubstring1);
                    
                    NSData *jsonData = [rowSubstring1 dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *jsonObject=[NSJSONSerialization
                    JSONObjectWithData:jsonData
                    options:NSJSONReadingMutableLeaves
                    error:nil];
                    NSLog(@"jsonObject is %@",jsonObject);
                    
                    
                    
                    [dataArray addObject:jsonObject];
                    if ([newStr rangeOfString: @"}"].location + 2 < newStr.length) {
                        [newStr deleteCharactersInRange: NSMakeRange(0, match.location + 2)];
                    }
                    else{
                        [newStr deleteCharactersInRange: NSMakeRange(0, newStr.length)];
                    }
                    
                    
                    [datasourceDynamicArray addObject:[jsonObject objectForKey:@"title"]];
                    [dynamicChallengeDataCache setValue:[[jsonObject objectForKey:@"questionIds"] componentsSeparatedByString:@";"] forKey:[jsonObject objectForKey:@"title"]];
                    if ([jsonObject objectForKey:@"borders"] != NULL) {
                        [dynamicChallengeDataCache setValue:@YES forKey:[NSString stringWithFormat:@"%@_%@",[jsonObject objectForKey:@"title"],@"borders"]];
                    }
                    else
                    {
                        [dynamicChallengeDataCache setValue:@NO forKey:[NSString stringWithFormat:@"%@_%@",[jsonObject objectForKey:@"title"],@"borders"]];
                    }
                    
                    if ([jsonObject objectForKey:@"completed"] != NULL) {
                        [dynamicChallengeDataCache setValue:@YES forKey:[NSString stringWithFormat:@"%@_%@",[jsonObject objectForKey:@"title"],@"completed"]];
                    }
                    else
                    {
                        [dynamicChallengeDataCache setValue:@NO forKey:[NSString stringWithFormat:@"%@_%@",[jsonObject objectForKey:@"title"],@"completed"]];
                    }
                    
                    
                    ind ++;
                }
                */
                
                
            }
            if response != nil
            {
                println("\(response)")
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