//
//  ResultItemView.swift
//  PlaceInTime
//
//  Created by knut on 17/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation


class ResultItemView: UIView
{
    var title:String!
    var stateWin:Int = 0
    var stateLoss:Int = 0
    var newRecord:Bool = false
    var opponentFullName:String!
    var opponentFirstName:String!
    var opponentId:String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, myCS:Int,myPoints:Int,opponentName:String,opponentId:String,opponentCS:Int,opponentPoints:Int, title:String, date:String, newRecord:Bool = false) {
        super.init(frame: frame)
        
        let margin:CGFloat = 0
        let secondLevelTitleWidth:CGFloat = (self.bounds.width - ( margin * 2)) / 6
        let titleElementHeight:CGFloat = 40
        
        opponentFullName = opponentName
        opponentFirstName = opponentName
        if opponentFullName.componentsSeparatedByString(" ").count > 1
        {
            opponentFirstName = opponentFullName.componentsSeparatedByString(" ").first!
        }
        
        stateWin = 1
        if myCS < opponentCS
        {
            stateWin = 0
            stateLoss = 1
        }
        else if myCS == opponentCS && myPoints < opponentPoints
        {
            stateWin = 0
            stateLoss = 1
        }
        else if myCS == opponentCS && myPoints == opponentPoints
        {
            stateWin = 0
        }
        
        var state = "✅"
        if stateWin == 0 && stateLoss == 1
        {
            state = "❌"
        }
        else if stateWin == 0
        {
            state = "➖"
        }
        if newRecord
        {
            state = "\(state)🆕"
        }
        
        let myStateLabel = UILabel(frame: CGRectMake(margin , 0, secondLevelTitleWidth, titleElementHeight))
        myStateLabel.textAlignment = NSTextAlignment.Center
        myStateLabel.text = "\(state)"
        myStateLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(myStateLabel)
        
        let myScoreCorrectSequenceLabel = UILabel(frame: CGRectMake(myStateLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        myScoreCorrectSequenceLabel.textAlignment = NSTextAlignment.Center
        myScoreCorrectSequenceLabel.text = "\(myCS)"
        myScoreCorrectSequenceLabel.numberOfLines = 2
        myScoreCorrectSequenceLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(myScoreCorrectSequenceLabel)
        
        let myScorePointsLabel = UILabel(frame: CGRectMake(myScoreCorrectSequenceLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        myScorePointsLabel.textAlignment = NSTextAlignment.Center
        myScorePointsLabel.text = "\(myPoints)"
        myScorePointsLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(myScorePointsLabel)
        
        
        
        let opponentNameLabel = UILabel(frame: CGRectMake(myScorePointsLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        opponentNameLabel.textAlignment = NSTextAlignment.Center
        opponentNameLabel.text = "\(opponentFirstName)"
        opponentNameLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(opponentNameLabel)
        
        let opponentScoreCorrectSequenceLabel = UILabel(frame: CGRectMake(opponentNameLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        opponentScoreCorrectSequenceLabel.textAlignment = NSTextAlignment.Center
        opponentScoreCorrectSequenceLabel.text = "\(opponentCS)"
        opponentScoreCorrectSequenceLabel.numberOfLines = 2
        opponentScoreCorrectSequenceLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(opponentScoreCorrectSequenceLabel)
        
        let opponentScorePointsLabel = UILabel(frame: CGRectMake(opponentScoreCorrectSequenceLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        opponentScorePointsLabel.textAlignment = NSTextAlignment.Center
        opponentScorePointsLabel.text = "\(opponentPoints)"
        opponentScorePointsLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(opponentScorePointsLabel)
    }
}