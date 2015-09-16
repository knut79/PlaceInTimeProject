//
//  File.swift
//  PlaceInTime
//
//  Created by knut on 14/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation

class Challenge {

    var fbIdToBeat:String!
    //var questions:[[HistoricEvent]]!
    var questionBlocks:[[Int]] = []
    var pointsToBeat:Int
    var correctAnswersToBeat:Int
    let datactrl = DataHandler()
    
    init(values:NSDictionary)
    {
        fbIdToBeat = values["fbIdToBeat"] as! String
        pointsToBeat = values["pointsToBeat"] as! Int
        correctAnswersToBeat = values["correctAnswersToBeat"] as! Int
        var questionsStringFormat = values["questionsStringFormat"] as! String
        
        let questionBlocksStringFormat = questionsStringFormat.componentsSeparatedByString(";")
        for item in questionBlocksStringFormat
        {
            let questionIds = item.componentsSeparatedByString(",")
            var idsArray:[Int] = []
            for id in questionIds
            {
                let idAsNumber = NSNumberFormatter().numberFromString(id)
                idsArray.append(idAsNumber!.integerValue)
            }
            questionBlocks.append(idsArray)
        }
    }
    
    func getNextQuestionBlock() -> [Int]
    {
        return questionBlocks.removeLast()
    }
}


