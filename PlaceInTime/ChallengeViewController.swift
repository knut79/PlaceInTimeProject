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
import FBSDKShareKit

class ChallengeViewController:UIViewController,FBSDKLoginButtonDelegate, UserViewProtocol {
    
    var passingLevelLow:Int!
    var passingLevelHigh:Int!
    var passingTags:[String] = []
    
    var usersToChallenge:[String] = []
    var userId:String!
    var userName:String!
    
    var usersToChallengeScrollView:UserScrollView!
    var challengeScrollView:ChallengeScrollView!
    var gametype:GameType!
    
    var playButton:UIButton!
    var backButton = UIButton()
    var activityLabel:UILabel!
    var activityIndicator:UIActivityIndicatorView!
    var addRandomUserButton:UIButton!
    var titleLabel:UILabel!
    var challengeIdsCommaSeparated:String!
    var client: MSClient?
    var challengeQuestionBlocksIds:[[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 40, 50))
        activityLabel.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        activityLabel.textAlignment = NSTextAlignment.Center
        activityLabel.adjustsFontSizeToFitWidth = true
        activityLabel.alpha = 0
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: 0,y:0, width: 50, height: 50)
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityLabel)
        view.addSubview(activityIndicator)
        
        self.client = (UIApplication.sharedApplication().delegate as! AppDelegate).client
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            //self.performSegueWithIdentifier("segueFromLoginToPlay", sender: nil)
            activityLabel.text = "Loading.."
            activityLabel.alpha = 1
            activityIndicator.startAnimating()
            
            initUserData({() -> Void in
                if self.gametype == GameType.makingChallenge
                {
                    self.initUserFriends()
                }
                if self.gametype == GameType.takingChallenge
                {
                    self.initChallenges()
                }
            })
            
        }
        else
        {
            let loginButton: FBSDKLoginButton = FBSDKLoginButton()
            // Optional: Place the button in the center of your view.
            loginButton.center = self.view.center
            loginButton.delegate = self
            loginButton.readPermissions = ["public_profile", "user_friends"]
            self.view.addSubview(loginButton)
        }
        
        let backButtonMargin:CGFloat = 15
        backButton.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width - GlobalConstants.smallButtonSide - backButtonMargin, backButtonMargin, GlobalConstants.smallButtonSide, GlobalConstants.smallButtonSide)
        backButton.backgroundColor = UIColor.whiteColor()
        backButton.layer.borderColor = UIColor.grayColor().CGColor
        backButton.layer.borderWidth = 1
        backButton.layer.cornerRadius = 5
        backButton.layer.masksToBounds = true
        backButton.setTitle("🔙", forState: UIControlState.Normal)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(backButton)
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
            activityLabel.alpha = 1
            activityLabel.text = "Loading.."
            activityIndicator.startAnimating()
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("user_friends")
            {
                // Do work
                initUserData({() -> Void in
                    if self.gametype == GameType.makingChallenge
                    {
                        self.initUserFriends()
                    }
                    if self.gametype == GameType.takingChallenge
                    {
                        self.initChallenges()
                    }
                })
            }
            else
            {
                //TODO show logout button and message telling that friends list must be premitted to continue
            }
            
            
        }
    }
    
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        
    }
    
    func initUserData(completion: (() -> (Void)))
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
                completion()
            }
            else
            {
                print("fetched user: \(result)")
                let userName : String = result.valueForKey("name") as! String
                print("User Name is: \(userName)")
                self.userName = userName
                let userId2 = result.valueForKey("id") as! String
                print("UserId2 is: \(userId2)")
                self.userId = userId2
                
                result
                self.updateUser({() -> Void in
                    
                    self.activityLabel.alpha = 0
                    self.activityIndicator.stopAnimating()
                    
                    completion()
                })
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
                print("Error: \(error)")
                let reportError = (UIApplication.sharedApplication().delegate as! AppDelegate).reportErrorHandler
                let alertController = reportError?.alertController("\(error)")
                self.presentViewController(alertController!,
                    animated: true,
                    completion: nil)
            }
            else
            {
                print("fetched friends result: \(result)")

                let friendObjects = result.valueForKey("data") as! [NSDictionary]
                self.initForNewChallenge(friendObjects)
                result
            }
        })
    }
    
    func initCommonElements(margin:CGFloat,elementWidth:CGFloat,elementHeight:CGFloat)
    {
        titleLabel = UILabel(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (elementWidth / 2), margin, elementWidth, elementHeight))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont.boldSystemFontOfSize(24)
        
        
        self.playButton = UIButton(frame:CGRectMake(titleLabel.frame.minX, UIScreen.mainScreen().bounds.size.height - margin - elementHeight, elementWidth , elementHeight))
        self.playButton.addTarget(self, action: "playAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.playButton.backgroundColor = UIColor.blueColor()
        self.playButton.layer.cornerRadius = 5
        self.playButton.layer.masksToBounds = true
        self.playButton.setTitle("Play", forState: UIControlState.Normal)
    }
    
    func initForNewChallenge(friendObjects:[NSDictionary])
    {
        var initialValues:[String:String] = [:]
        for friendObject in friendObjects {
            initialValues.updateValue(friendObject.valueForKey("id") as! String, forKey: friendObject.valueForKey("name") as! String )
        }
        
        let minNumberOfItemsOnGamerecordRow = 6
        let datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl
        datactrl.loadGameData()
        for record in datactrl.gameResultsValues
        {
            let arrayOfValues = record.componentsSeparatedByString(",")
            if arrayOfValues.count == minNumberOfItemsOnGamerecordRow
            {
                let name = arrayOfValues[1]
                let opponentId = arrayOfValues[5]
                
                var found = false
                for item in initialValues
                {
                    if item.1 == opponentId
                    {
                        found = true
                        break;
                    }
                }
                if !found
                {
                    initialValues.updateValue(opponentId,forKey: name)
                }
            }
        }


        let margin:CGFloat = 10
        let elementWidth:CGFloat = 200
        let elementHeight:CGFloat = 40

        self.initCommonElements(margin,elementWidth: elementWidth,elementHeight: elementHeight)
        
        titleLabel.text = "Challenge users"

        let content = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "https://itunes.apple.com/no/app/timeline-feud/id1042085872?mt=8")
        content.imageURL = NSURL(string: "https://scontent-arn2-1.xx.fbcdn.net/hphotos-xfp1/t39.2081-0/p128x128/12057066_543965822434535_846423925_n.png")
        content.contentDescription = "Test this iOS history battle game and challenge me"
        content.contentTitle = "Timeline feud"
        
        let inviteFriendsButton = FBSDKSendButton()
        inviteFriendsButton.frame = CGRectMake(titleLabel.frame.minX, playButton.frame.minY - margin - elementHeight, elementWidth , elementHeight)
        inviteFriendsButton.shareContent = content
        inviteFriendsButton.layer.cornerRadius = 5
        inviteFriendsButton.layer.masksToBounds = true
        inviteFriendsButton.setTitle("Invite friends", forState: UIControlState.Normal)
        
        let scrollViewHeight =  inviteFriendsButton.frame.minY - titleLabel.frame.maxY - ( margin * 2 )
        let scrollViewWidth = UIScreen.mainScreen().bounds.size.width * 0.9 - (margin * 2)
        self.usersToChallengeScrollView = UserScrollView(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (scrollViewWidth / 2) , titleLabel.frame.maxY + margin, scrollViewWidth, scrollViewHeight),initialValues:initialValues, itemsChecked:false)
        self.usersToChallengeScrollView.delegate = self
        self.usersToChallengeScrollView.alpha = 1
        
        let addRandomUserButtonSide = GlobalConstants.smallButtonSide
        addRandomUserButton = UIButton(frame:CGRectMake(usersToChallengeScrollView.frame.minX + margin, usersToChallengeScrollView.frame.minY, addRandomUserButtonSide * 2 , addRandomUserButtonSide))
        self.addRandomUserButton.addTarget(self, action: "addRandomUserAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.addRandomUserButton.backgroundColor = UIColor.clearColor()
        self.addRandomUserButton.layer.cornerRadius = 5
        self.addRandomUserButton.layer.masksToBounds = true
        self.addRandomUserButton.setTitle("+🃏", forState: UIControlState.Normal)
        
        view.addSubview(titleLabel)
        view.addSubview(playButton)
        view.addSubview(inviteFriendsButton)
        view.addSubview(usersToChallengeScrollView)
        view.addSubview(addRandomUserButton)
        view.addSubview(activityLabel)
        
        if friendObjects.count == 0
        {
            
            addRandomUser( { () in
                self.activityLabel.alpha = 0
                self.activityLabel.text = "No facebook friends with this app😢"
                
                let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity");
                pulseAnimation.duration = 0.3
                pulseAnimation.toValue = NSNumber(float: 0.3)
                pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                pulseAnimation.autoreverses = true;
                pulseAnimation.repeatCount = 5
                self.addRandomUserButton.layer.addAnimation(pulseAnimation, forKey: "asd")
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
        let scrollViewWidth = UIScreen.mainScreen().bounds.size.width - (margin * 2)
        self.challengeScrollView = ChallengeScrollView(frame: CGRectMake(margin , titleLabel.frame.maxY + margin, scrollViewWidth, scrollViewHeight), itemsChecked:false)
        //self.challengeScrollView.delegate = self
        self.challengeScrollView.alpha = 1
        
        view.addSubview(titleLabel)
        playButton.alpha = 0
        view.addSubview(playButton)
        view.addSubview(backButton)
        view.addSubview(challengeScrollView)
        view.addSubview(activityLabel)
        
        self.requestChallenges()
        

    }
    
    
    //OBSOLETE _?
    func requestChallenges()
    {
        let jsonDictionary = ["fbid":userId]
        //var jsonDictionary = ["fbid":"10155943015600858","name":userName]
        
        self.client!.invokeAPI("challenge", data: nil, HTTPMethod: "GET", parameters: jsonDictionary, headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                print(error)
                let reportError = (UIApplication.sharedApplication().delegate as! AppDelegate).reportErrorHandler
                let alertController = reportError?.alertController("\(error)")
                self.presentViewController(alertController!,
                    animated: true,
                    completion: nil)
            }
            if result != nil
            {
                //Note ! root json object is not a dictionary but an array
                
                do{
                    let jsonArray = try NSJSONSerialization.JSONObjectWithData(result, options: NSJSONReadingOptions.MutableContainers) as? NSArray
                    
                    if let array = jsonArray
                    {
                        for item in array {
                            print("item : \(item)")
                            if let jsonDictionary = item as? NSDictionary {
                                let title = jsonDictionary["title"] as! String
                                self.challengeScrollView.addItem(title,value: jsonDictionary)
                                
                                self.activityLabel.alpha = 0
                                self.playButton.alpha = 1
                            }
                        }
                        if jsonArray?.count == 0
                        {
                            self.activityLabel.text = "No pending challenges from other users😒"
                        }
                    }
                }
                catch
                {
                    self.activityLabel.text = "\(error)"
                }
                
            }
            if response != nil
            {
                print("\(response)")
            }
        })
    }
    
    func updateUser(completionClosure: (() -> Void) )
    {
        
        let deviceToken = NSUserDefaults.standardUserDefaults().stringForKey("deviceToken")
        let jsonDictionary = ["fbid":userId,"name":userName,"token":deviceToken]
        
        self.client!.invokeAPI("updateuser", data: nil, HTTPMethod: "POST", parameters: jsonDictionary, headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                print("\(error)")
                
                let reportError = (UIApplication.sharedApplication().delegate as! AppDelegate).reportErrorHandler
                let alertController = reportError?.alertController("\(error)")
                self.presentViewController(alertController!,
                    animated: true,
                    completion: nil)
            }
            /*
            if result != nil
            {
            
            }
            */
            if response != nil
            {
                print("\(response)")
            }
            
            completionClosure()
        })
    }
    
    
    var randomUsersAdded = 0
    func addRandomUserAction()
    {
        addRandomUser(nil)
    }
    
    func addRandomUser(completionClosure: (() -> Void)? )
    {
        activityLabel.alpha = 1
        activityLabel.text = "Collecting random user..."
        randomUsersAdded++
        if randomUsersAdded > 2
        {
            activityLabel.alpha = 0
            addRandomUserButton.alpha = 0
        }
        var userUsed:String = usersToChallengeScrollView.getAllItemsValueAsStringFormat()
        userUsed = "\(userUsed)\(self.userId)"
        
        let jsonDictionary = ["fbid":userId,"name":userName,"usedusers":userUsed]
        
        self.client!.invokeAPI("randomuser", data: nil, HTTPMethod: "GET", parameters: jsonDictionary, headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                print("\(error)")
            }
            if result != nil
            {
                //Note ! root json object is not a dictionary but an array

                do {
                    let json: AnyObject = try NSJSONSerialization.JSONObjectWithData(result, options: [])
                    if let jsonDictionary = json as? NSDictionary { // Check 3
                        print("Dictionary received")
                        let name = jsonDictionary["name"] as! String
                        let fbId = jsonDictionary["fbid"] as! String
                        self.usersToChallengeScrollView.addItem("\(name) (random user)", value: fbId)
                    }
                } catch let error as NSError {
                    print(error)
                } catch {
                    fatalError()
                }
                
            }
            if response != nil
            {
                print("\(response)")
            }
            self.activityLabel.alpha = 0
            completionClosure?()
        })
        
    }
    
    
    var questionBlockIds:String?
    var challengeName:String!
    func sendChallengeMakingStart()
    {
        let firstNameInUserName = userName.componentsSeparatedByString(" ").count > 1 ? userName.componentsSeparatedByString(" ").first : userName
        challengeName = "\(passingLevelLow)-\(passingLevelHigh) from \(firstNameInUserName)"
        let questionBlockIds = questionsToCommaseparated()
        let toIds:String = usersToCommaseparated()
        
        print("fbid:\(userId) chname:\(challengeName) toIdsPar:\(toIds) questionsPar:\(questionBlockIds)")
        
        let jsonDictionary = ["fbid":userId,"chname":challengeName,"toIdsPar":toIds,"questionsPar":questionBlockIds]
        
        self.client!.invokeAPI("startmakingchallenge", data: nil, HTTPMethod: "POST", parameters: jsonDictionary, headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                print("\(error)")
                self.activityLabel.text = "Server error"
                let reportError = (UIApplication.sharedApplication().delegate as! AppDelegate).reportErrorHandler
                let alertController = reportError?.alertController("\(error)")
                self.presentViewController(alertController!,
                    animated: true,
                    completion: nil)
            }
            if result != nil
            {
                print(result)
                ///backstabbing cock!!!.. is there really no way of escaping double quotes directly from json string...
                
                let temp = NSString(data: result, encoding:NSUTF8StringEncoding) as! String
                self.challengeIdsCommaSeparated = String(temp.characters.dropLast().dropFirst())
                
                self.performSegueWithIdentifier("segueFromChallengeToPlay", sender: nil)
            }
            if response != nil
            {
                print("\(response)")
            }
            
        })
        
    }
    
    func sendChallengeTakenStart()
    {
        
        let values = self.challengeScrollView.getSelectedValue()
        let challengeId = values!["challengeId"] as! String
        
        print("challengeId:\(challengeId)")
        let jsonDictionary = ["chid":challengeId]
        
        self.client!.invokeAPI("starttakingchallenge", data: nil, HTTPMethod: "POST", parameters: jsonDictionary, headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                print("\(error)")
                self.activityLabel.text = "Server error"
                let reportError = (UIApplication.sharedApplication().delegate as! AppDelegate).reportErrorHandler
                let alertController = reportError?.alertController("\(error)")
                self.presentViewController(alertController!,
                    animated: true,
                    completion: nil)
            }
            if result != nil
            {
                
                print(result)
                self.performSegueWithIdentifier("segueFromChallengeToPlay", sender: nil)
            }
            if response != nil
            {
                print("\(response)")
            }
            
            
        })
    }
    
    func usersToCommaseparated() -> String
    {
        var returnString:String = ""
        for item in usersToChallenge
        {
            returnString += item + ","
            
        }
        return String(returnString.characters.dropLast())
    }
    
    func questionsToCommaseparated() -> String
    {
        let datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl

        challengeQuestionBlocksIds = datactrl.fetchQuestoinsForChallenge()

        var returnString:String = ""
        for questionBlock in challengeQuestionBlocksIds
        {
            for question in questionBlock
            {
                returnString += question + ","
            }
            returnString = String(returnString.characters.dropLast())
            returnString += ";"
        }
        return String(returnString.characters.dropLast())


    }
    
    func playAction()
    {
        if self.gametype == GameType.makingChallenge
        {
            usersToChallenge = self.usersToChallengeScrollView.getCheckedItemsValueAsArray()
            
            if usersToChallenge.count < 1
            {
                let alert = UIAlertView(title: "Pick 1", message: "Select at least 1 user", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            else
            {
                self.view.bringSubviewToFront(activityLabel)
                self.view.bringSubviewToFront(activityIndicator)
                activityIndicator.startAnimating()
                self.activityLabel.text = "Loading game.."
                sendChallengeMakingStart()
            }
        }
        else if self.gametype == GameType.takingChallenge
        {
            let selectedValue = challengeScrollView.getSelectedValue()
            if selectedValue == nil
            {
                let alert = UIAlertView(title: "Pick 1", message: "Select a challenge", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                
            }
            else
            {
                self.view.bringSubviewToFront(activityLabel)
                self.view.bringSubviewToFront(activityIndicator)
                activityIndicator.startAnimating()
                self.activityLabel.text = "Loading game.."
                sendChallengeTakenStart()
            }
        }
    }
    
    func backAction()
    {
        self.performSegueWithIdentifier("segueFromChallengeToMainMenu", sender: nil)
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueFromChallengeToPlay") {
            let svc = segue!.destinationViewController as! PlayViewController
            svc.gametype = gametype
            
            self.activityIndicator.stopAnimating()
            if self.gametype == GameType.makingChallenge
            {
                let makingChallenge = MakingChallenge(challengesName: challengeName,users:usersToChallenge, questionBlocks: challengeQuestionBlocksIds, challengeIds: challengeIdsCommaSeparated!)
                svc.challenge = makingChallenge

            }
            else if self.gametype == GameType.takingChallenge
            {
                let values = self.challengeScrollView.getSelectedValue()
                svc.challenge = TakingChallenge(values: values!)
            }
            
            svc.myIdAndName = (self.userId,self.userName)
        }
    }

    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft, UIInterfaceOrientationMask.LandscapeRight]
    }

}