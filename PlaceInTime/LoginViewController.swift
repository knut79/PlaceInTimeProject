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

class LoginViewController:UIViewController,FBSDKLoginButtonDelegate {
    
    var passingLevelLow:Int!
    var passingLevelHigh:Int!
    var passingTags:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            //self.performSegueWithIdentifier("segueFromLoginToPlay", sender: nil)
            
            returnUserData()
            returnUserFriends()
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
                self.performSegueWithIdentifier("segueFromLoginToPlay", sender: nil)
            }
        }
    }
    
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        
    }
    
    func returnUserData()
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
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User Name is: \(userName)")
                
                let userId = result.objectID
                println("UserId is: \(userId)")
                
                
                
                let userId2 = result.valueForKey("id")
                println("UserId2 is: \(userId2)")
                
                
                result
            }
        })
    }
    
    func returnUserFriends()
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
                for friendObject in friendObjects {
                    let name = friendObject.valueForKey("name") as! String
                    let id = friendObject.valueForKey("id")
                    println("\(name)")
                    println("\(id!)")
                }
                
                result
            }
        })
    }
    
    /*
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
    initWithGraphPath:@"/me/friends"
    parameters:params
    HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
    id result,
    NSError *error) {
    // Handle the result
    }];
*/
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueFromLoginToPlay") {
            var svc = segue!.destinationViewController as! PlayViewController
            svc.levelLow = passingLevelLow
            svc.levelHigh = passingLevelHigh
            svc.tags = passingTags
            svc.gametype = gameType.challenge
        }
    }
}