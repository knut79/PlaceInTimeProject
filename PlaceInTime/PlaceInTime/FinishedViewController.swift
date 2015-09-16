//
//  FinishedViewController.swift
//  PlaceInTime
//
//  Created by knut on 08/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit

class FinishedViewController:UIViewController {
    
    var usersIdsToChallenge:[String] = []
    var completedQuestionsIds:[[String]] = []
    var challengeName:String!
    
    var userFbId:String!
    var correctAnswers:Int!
    var points:Int!
    var gametype:gameType!
    var challengeid:String = ""
    var challengeToBeat:Challenge!
    var client: MSClient?
    
    var activityLabel:UILabel!
    var backToMenuButton:UIButton!
    
    
    var resultLabel:UILabel!
    
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
        
        activityLabel = UILabel(frame: CGRectMake(0, 0, 400, 50))
        activityLabel.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        activityLabel.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(sendingChallengeLabel)
        
        
        if gametype == gameType.makingChallenge
        {
            newChallenge()
            activityLabel.text = "Sending challenge \(challengeName)"
        }
        
        if gametype == gameType.takingChallenge
        {
            
            activityLabel.text = "Sending result of \(challengeName)"
            respondToChallenge()
            
            var resultChallengeLabel = UILabel(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - 200, 25, 400, 50))
            resultChallengeLabel.textAlignment = NSTextAlignment.Center
            resultChallengeLabel.text = "Result of challenge \(challengeName)"
            self.view.addSubview(resultChallengeLabel)
            
            
            resultLabel = UILabel(frame: CGRectMake(margin, resultChallengeLabel.frame.maxY + margin, UIScreen.mainScreen().bounds.size.width - (margin * 2), UIScreen.mainScreen().bounds.size.height - resultChallengeLabel.frame.height - (margin * 2)))
            resultLabel.numberOfLines = 5
            resultLabel.textAlignment = NSTextAlignment.Center
            self.view.addSubview(resultLabel)
            
            
            //sending result
            
            if correctAnswers > challengeToBeat.correctAnswersToBeat
            {
                youWonChallenge()
            }
            else if correctAnswers == challengeToBeat.correctAnswersToBeat && points > challengeToBeat.pointsToBeat
            {
                youWonChallenge()
            }
            else
            {
                youLostChallenge()
            }
        }
    }
    
    func youLostChallenge()
    {
        resultLabel.text = "You lost 😖/n" +
            "\(correctAnswers) correct answers" + "/n\(points) points" +
            "against" +
            "\(challengeToBeat.correctAnswersToBeat) correct answers" + "/n\(challengeToBeat.pointsToBeat) points"
    }
    
    func youWonChallenge()
    {
        resultLabel.text = "You won 😆/n" +
        "\(correctAnswers) correct answers" + "/n\(points) points" +
        "against" +
        "\(challengeToBeat.correctAnswersToBeat) correct answers" + "/n\(challengeToBeat.pointsToBeat) points"
    }
    
    func test1()
    {
        var url : String = "http://google.com?test=toto&test2=titi"
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: url)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonResult: NSDictionary! = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
            
            if (jsonResult != nil) {
                // process jsonResult
            } else {
                // couldn't load JSON, look at error
            }
            
            
        })
    }
    
    func test2()
    {
        var jsonDictionary = ["id":challengeName]
        //var completion = MSAPIDataBlock
        

        
        self.client!.invokeAPI("DynamicChallenge", data: nil, HTTPMethod: "GET", parameters: jsonDictionary, headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                println("\(error)")
            }
            if result != nil
            {
                println("\(result)")
            }
            if response != nil
            {
                println("\(response)")
            }
        })
    }
    
    func test3()
    {
        var jsonDictionary = ["level":"1"]
        self.client!.invokeAPI("test", data: nil, HTTPMethod: "POST", parameters: jsonDictionary, headers: nil, completion: { (data:NSData!, response:NSHTTPURLResponse!, error:NSError?) -> Void in
            if error != nil
            {
                println("Error \(error)")
            }
        })
    }
    
    func testRandomUser()
    {
        var jsonDictionary = ["id":"6744567","usedusers":"123;345;678"]
        self.client!.invokeAPI("randomuser", data: nil, HTTPMethod: "GET", parameters: jsonDictionary, headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                println("\(error)")
            }
            if result != nil
            {
                println("\(result)")
            }
            if response != nil
            {
                println("\(response)")
            }
        })
    }
    
    func testNewUser()
    {
        var jsonDictionary = ["fbid":"111222333","name":"knut dullumsen"]
        self.client!.invokeAPI("adduser", data: nil, HTTPMethod: "POST", parameters: jsonDictionary, headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                println("\(error)")
            }
            if result != nil
            {
                println("\(result)")
            }
            if response != nil
            {
                println("\(response)")
            }
        })
    }
    
    func newChallenge()
    {
        
        var questionIds:String = questionsToFormattedString()
        //var jsonDictionary = ["title":"heihei","fromId":"123","fromResultPoints":"333","fromResultCorrect":"3","toIds":toIdsArray,"questions":questionsArray]
        var toIds:String = usersToCommaseparatedString()
        //var dataPass = .dataWithJSONObject(toIdsArray, options: NSJSONWritingOptions.allZeros, error: nil)
        //var dataTest = NSJSONSerialization.dataWithJSONObject(
        var jsonDictionary = ["title":challengeName,"fromId":userFbId,"fromResultPoints":points,"fromResultCorrect":correctAnswers,"toIdsPar":toIds,"questionsPar":questionIds]
        self.client!.invokeAPI("challenge", data: nil, HTTPMethod: "POST", parameters: jsonDictionary as [NSObject : AnyObject], headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                backToMenuButton.alpha = 1
                activityLabel.text = "\(error)"
            }
            if result != nil
            {
                println("\(result)")
                
                backToMenuButton.alpha = 1
                activityLabel.alpha = 0
            }
            if response != nil
            {
                println("\(response)")
            }
        })
    }
    
    func respondToChallenge()
    {
        var jsonDictionary = ["userfbid":userFbId,"challengeid":challengeid,"resultpoints":points,"resultcorrect":correctAnswers]
        self.client!.invokeAPI("finishchallenge", data: nil, HTTPMethod: "POST", parameters: jsonDictionary as [NSObject : AnyObject], headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                backToMenuButton.alpha = 1
                activityLabel.text = "\(error)"
            }
            if result != nil
            {
                println("\(result)")
                
                backToMenuButton.alpha = 1
                activityLabel.alpha = 0
            }
            if response != nil
            {
                println("\(response)")
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
        return dropLast(returnString)
    }
    
    func questionsToFormattedString() -> String
    {
        var returnString:String = ""
        for questionBlock in completedQuestionsIds
        {
            for question in questionBlock
            {
                returnString += question + ","
            }
            returnString = dropLast(returnString)
            returnString += ";"
        }
        return dropLast(returnString)
        
    }
    
    func backToMenuAction()
    {
        self.performSegueWithIdentifier("segueFromFinishedToMainMenu", sender: nil)
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueFromFinishedToMainMenu") {
            var svc = segue!.destinationViewController as! MainMenuViewController
            if gameStats.newValues()
            {
                svc.updateGlobalGameStats = true
                svc.newGameStatsValues = (points,0,correctAnswers)
                //svc.imagefile = currentImagefile
            }
        }

    }
    
    /*
    func sendChallenge()
    {
        let url = NSURL(string: "http://myrestservice")
        let theRequest = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(theRequest, queue: nil, completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if data.length > 0 && error == nil {
                let response : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.fromMask(0), error: nil)
            }
        })
    }
    */
    
    /*
    - (void) sendChallenge:(NSDictionary*) jsonDictionary completion:(MSAPIDataBlock)completion
    {
    //NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys: @"1", @"level", nil];
    [self.client
    invokeAPI:@"dynamicchallenge"
    data:nil
    HTTPMethod:@"POST"
    parameters:jsonDictionary
    headers:nil
    completion:completion ];
    }
    */
}