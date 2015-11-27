//
//  FinishedViewController.swift
//  PlaceInTime
//
//  Created by knut on 08/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//
import AVFoundation
import Foundation
import UIKit

class FinishedViewController:UIViewController {
    
    var usersIdsToChallenge:[String] = []
    var completedQuestionsIds:[[String]] = []
    
    var userFbId:String!
    var correctAnswers:Int!
    var points:Int!
    var gametype:GameType!
    var challenge:Challenge!
    var client: MSClient?
    
    var activityLabel:UILabel!
    var backToMenuButton:UIButton!
    var resultLabel:UILabel!
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.client = (UIApplication.sharedApplication().delegate as! AppDelegate).client
        
        /*
        self.client = MSClient(
            applicationURLString:"https://placeintime.azure-mobile.net/",
            applicationKey:"EPexqUWpxpiDBffWuGuiNUgjgTzeMz22"
        )
        */
        let margin:CGFloat = 20
        let elementWidth:CGFloat = 200
        let elementHeight:CGFloat = 40
        backToMenuButton = UIButton(frame:CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (elementWidth / 2), UIScreen.mainScreen().bounds.size.height - margin - elementHeight, elementWidth , elementHeight))
        backToMenuButton.addTarget(self, action: "backToMenuAction", forControlEvents: UIControlEvents.TouchUpInside)
        backToMenuButton.backgroundColor = UIColor.blueColor()
        backToMenuButton.layer.cornerRadius = 5
        backToMenuButton.layer.masksToBounds = true
        backToMenuButton.setTitle("Back to menu", forState: UIControlState.Normal)
        backToMenuButton.alpha = 0
        self.view.addSubview(self.backToMenuButton)
        
        activityLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 40, 50))
        activityLabel.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        activityLabel.adjustsFontSizeToFitWidth = true
        activityLabel.textAlignment = NSTextAlignment.Center
        activityLabel.font = UIFont.boldSystemFontOfSize(24)
        activityLabel.numberOfLines = 2
        
        
        self.view.addSubview(activityLabel)
        
        
        if gametype == GameType.makingChallenge
        {
            activityLabel.text = "Sending challenge"
            
            (UIApplication.sharedApplication().delegate as! AppDelegate).backgroundThread(background: {
                self.finishMakingChallenge()
                },
                completion: {
                    // A function to run in the foreground when the background thread is complete
            })
        }
        else if gametype == GameType.takingChallenge
        {
            if let takingChallenge = challenge as? TakingChallenge
            {
                activityLabel.text = "Sending result of\n\(takingChallenge.title!)"
                finishTakingChallenge(takingChallenge)
                
                let resultChallengeLabel = UILabel(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - 200, 10, 400, 50))
                resultChallengeLabel.textAlignment = NSTextAlignment.Center
                resultChallengeLabel.text = "Result of challenge \(self.challenge.title)"
                resultChallengeLabel.font = UIFont.boldSystemFontOfSize(20)
                resultChallengeLabel.adjustsFontSizeToFitWidth = true
                self.view.addSubview(resultChallengeLabel)
                
                resultLabel = UILabel(frame: CGRectMake(margin, resultChallengeLabel.frame.maxY , UIScreen.mainScreen().bounds.size.width - (margin * 2), UIScreen.mainScreen().bounds.size.height - resultChallengeLabel.frame.maxY - (margin * 2) - backToMenuButton.frame.height))
                resultLabel.numberOfLines = 9
                resultLabel.backgroundColor = UIColor.grayColor()
                resultLabel.textAlignment = NSTextAlignment.Center
                resultLabel.textColor = UIColor.whiteColor()
                resultLabel.adjustsFontSizeToFitWidth = true
                resultLabel.backgroundColor = UIColor.blueColor()
                resultLabel.layer.borderColor = UIColor.whiteColor().CGColor
                resultLabel.layer.cornerRadius = 8
                resultLabel.layer.masksToBounds = true
                resultLabel.layer.borderWidth = 5.0
                self.view.addSubview(resultLabel)
                
                //sending result
                
                if correctAnswers > takingChallenge.correctAnswersToBeat
                {
                    youWonChallenge(takingChallenge)
                }
                else if correctAnswers == takingChallenge.correctAnswersToBeat && points > takingChallenge.pointsToBeat
                {
                    youWonChallenge(takingChallenge)
                }
                else if correctAnswers == takingChallenge.correctAnswersToBeat && points == takingChallenge.pointsToBeat
                {
                    youDrewChallenge(takingChallenge)
                }
                else
                {
                    youLostChallenge(takingChallenge)
                }
            }
            self.view.addSubview(self.backToMenuButton)
        }
        else
        {
            print("invalid GameType")
            self.view.addSubview(self.backToMenuButton)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        if gametype == GameType.makingChallenge
        {
            self.performSegueWithIdentifier("segueFromFinishedToMainMenu", sender: nil)
        }
    }
    
    func youLostChallenge(takingChallenge:TakingChallenge)
    {
        let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("lostChallenge", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
        } catch let error1 as NSError {
            print(error1)
        }
        audioPlayer.numberOfLoops = 0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        resultLabel.text = "You lost 😖\n\n" +
            "\(correctAnswers) correct answers" + "\n\(points) points" +
            "\nvs." +
            "\n\(takingChallenge.correctAnswersToBeat) correct answers" + "\n\(takingChallenge.pointsToBeat) points"
    }
    
    func youWonChallenge(takingChallenge:TakingChallenge)
    {
        let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("fanfare2", ofType: "wav")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
        } catch let error1 as NSError {
            print(error1)
        }
        audioPlayer.numberOfLoops = 0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        resultLabel.text = "You won 😆\n\n" +
        "\(correctAnswers) correct answers" + "\n\(points) points" +
        "\n\nagainst" +
        "\n\n\(takingChallenge.correctAnswersToBeat) correct answers" + "\n\(takingChallenge.pointsToBeat) points"
    }
    
    func youDrewChallenge(takingChallenge:TakingChallenge)
    {
        let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("fanfare2", ofType: "wav")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
        } catch let error1 as NSError {
            print(error1)
        }
        audioPlayer.numberOfLoops = 0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        resultLabel.text = "Challenge ended as draw 😐\n\n" +
            "\(correctAnswers) correct answers" + "\n\(points) points" +
            "\n\nagainst" +
            "\n\n\(takingChallenge.correctAnswersToBeat) correct answers" + "\n\(takingChallenge.pointsToBeat) points"
    }
    
    
    func finishMakingChallenge()
    {
        let makingChallenge = challenge as! MakingChallenge
        let challengeIds = makingChallenge.challengeIds
        
        let jsonDictionary = ["chidspar":challengeIds!,"fromId":userFbId,"resultpoints":points,"resultcorrect":correctAnswers]
        self.client!.invokeAPI("finishmakingchallenge", data: nil, HTTPMethod: "POST", parameters: jsonDictionary as! [NSObject : AnyObject], headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                self.activityLabel.text = "Server error"
                let reportError = (UIApplication.sharedApplication().delegate as! AppDelegate).reportErrorHandler
                let alert = UIAlertView(title: "Server error", message: "Could not send challenge. Sorry for the annoyance.", delegate: nil, cancelButtonTitle: "OK")
                reportError?.reportError("\(error)",alert: alert)
            }
            if result != nil
            {
                
                print("\(result)")
                let temp = NSString(data: result, encoding:NSUTF8StringEncoding) as! String
                print("\(temp)")
                let numUsersChallenged = makingChallenge.usersToChallenge.count
                let alertText = numUsersChallenged > 1 ? "Challenge sendt to \(numUsersChallenged) users" : "Challenge sendt to \(numUsersChallenged) user"
                let alert = UIAlertView(title: "Sending challenge", message: alertText, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            if response != nil
            {
                print("\(response)")
            }
        })
    }
    
    func finishTakingChallenge(takingChallenge:TakingChallenge)
    {
        let jsonDictionary = ["userfbid":userFbId,"challengeid":takingChallenge.id,"resultpoints":points,"resultcorrect":correctAnswers]
        self.client!.invokeAPI("finishtakingchallenge", data: nil, HTTPMethod: "POST", parameters: jsonDictionary as! [NSObject : AnyObject], headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                self.backToMenuButton.alpha = 1
                let alert = UIAlertView(title: "Server error", message: "\(error)", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
            if result != nil
            {
                print("\(result)")
                
                self.backToMenuButton.alpha = 1
                self.activityLabel.alpha = 0
            }
            if response != nil
            {
                print("\(response)")
            }
            
            
        })
    }

    
    func usersToCommaseparatedString() -> String
    {
        var returnString:String = ""
        for item in usersIdsToChallenge
        {
            returnString += item + ","
            
        }
        return String(returnString.characters.dropLast())
    }
    
    //OBSOLETE _?
    func questionsToFormattedString() -> String
    {
        var returnString:String = ""
        for questionBlock in completedQuestionsIds
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
    
    func backToMenuAction()
    {
        self.performSegueWithIdentifier("segueFromFinishedToMainMenu", sender: nil)
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueFromFinishedToMainMenu") {
            let svc = segue!.destinationViewController as! MainMenuViewController

            svc.updateGlobalGameStats = true
            svc.newGameStatsValues = (points,0,correctAnswers)
        }

    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft, UIInterfaceOrientationMask.LandscapeRight]
    }

}