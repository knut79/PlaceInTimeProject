//
//  ResultsViewController.swift
//  PlaceInTime
//
//  Created by knut on 17/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class ResultsViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var client: MSClient?
    var activityLabel:UILabel!
    let backButton = UIButton()
    var titleLabel:UILabel!
    var userId:String!
    var userName:String!
    
    var resultsScrollView:ResultsScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.client = (UIApplication.sharedApplication().delegate as! AppDelegate).client
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            
            initUserData()
            
            

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
                
                
                self.initElements()
                
                result
            }
        })
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

            }
            else
            {
                //TODO show logout button and message telling that friends list must be premitted to continue
            }
            
            
        }
    }
    
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        
    }
    
    func initElements()
    {
        let margin:CGFloat = 10
        let elementWidth:CGFloat = 200
        let elementHeight:CGFloat = 40
        titleLabel = UILabel(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (elementWidth / 2), margin, elementWidth, elementHeight))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.text = "Results"
        view.addSubview(titleLabel)
        
        
        let scrollViewHeight =  UIScreen.mainScreen().bounds.size.height - titleLabel.frame.maxY - ( margin * 2 )
        var scrollViewWidth = UIScreen.mainScreen().bounds.size.width - (margin * 2)
        self.resultsScrollView = ResultsScrollView(frame: CGRectMake(margin , titleLabel.frame.maxY + margin, scrollViewWidth, scrollViewHeight))
        self.resultsScrollView.alpha = 1
        self.view.addSubview(self.resultsScrollView)
        
        
        activityLabel = UILabel(frame: CGRectMake(0, 0, 400, 50))
        activityLabel.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        activityLabel.textAlignment = NSTextAlignment.Center
        activityLabel.text = "Collecting new results..."
        self.view.addSubview(activityLabel)
        
        backButton.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width - smallButtonSide, 0, smallButtonSide, smallButtonSide)
        backButton.backgroundColor = UIColor.whiteColor()
        backButton.layer.borderColor = UIColor.grayColor().CGColor
        backButton.layer.borderWidth = 1
        backButton.setTitle("🔚", forState: UIControlState.Normal)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(backButton)

    }
    
    func collectNewResults()
    {
        
        //FB LOGIN
        var jsonDictionary = ["fbid":"123123"]
        
        self.client!.invokeAPI("collectchallenges", data: nil, HTTPMethod: "GET", parameters: jsonDictionary, headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                println("\(error)")
            }
            if result != nil
            {
                var e: NSError?
                var jsonArray = NSJSONSerialization.JSONObjectWithData(result, options: NSJSONReadingOptions.MutableContainers, error: &e) as? NSArray
                
                self.saveChallengeToPlist(jsonArray as! [NSDictionary])
                self.activityLabel.alpha = 0
                
            }
            if response != nil
            {
                println("\(response)")
            }
        })
    }
    
    func collectStoredResults()
    {
        
    }
    
    func saveChallengeToPlist(values:[NSDictionary])
    {
        
    }
    
    func backAction()
    {
        self.performSegueWithIdentifier("segueFromMainMenuToResults", sender: nil)
    }
    
}
