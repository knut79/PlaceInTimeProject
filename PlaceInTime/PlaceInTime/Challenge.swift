//
//  File.swift
//  PlaceInTime
//
//  Created by knut on 14/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation

class Challenge {


    var questionBlocks:[[String]] = []
    var challengeIds:String!
    var title:String!
    
    init()
    {
        questionBlocks = []

    }
    func getNextQuestionBlock() -> [String]
    {
        return questionBlocks.removeLast()
    }
}

class TakingChallenge: Challenge {
    
    var id:String!
    var fbIdToBeat:String!
    var pointsToBeat:Int!
    var usingBorders:Int!
    var correctAnswersToBeat:Int!
    
    
    let datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl
    
    init(values:NSDictionary)
    {
        super.init()
        
        title = values["title"] as! String
        id = values["challengeId"] as! String
        fbIdToBeat = values["fbIdToBeat"] as! String
        correctAnswersToBeat = values["correctAnswersToBeat"] as! Int
        pointsToBeat = values["pointsToBeat"] as! Int
        let questionsStringFormat = values["questionsStringFormat"] as! String
        
        let questionBlocksStringFormat = questionsStringFormat.componentsSeparatedByString(";")
        for item in questionBlocksStringFormat
        {
            let questionIds = item.componentsSeparatedByString(",")
            var idsArray:[String] = []
            for id in questionIds
            {
                idsArray.append(id)
            }
            questionBlocks.append(idsArray)
        }
    }
    

}

class MakingChallenge: Challenge {
    
    var usersToChallenge:[String] = []
    init(challengesName:String,users:[String], questionBlocks:[[String]], challengeIds:String)
    {
        super.init()
        self.title = challengesName
        self.questionBlocks = questionBlocks
        self.challengeIds = challengeIds
        self.usersToChallenge = users
    }
}


