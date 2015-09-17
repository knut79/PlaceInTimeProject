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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, myCS:Int,myPoints:Int,opponentName:String,opponentCS:Int,opponentPoints:Int) {
        super.init(frame: frame)
        
        let margin:CGFloat = 0
        let secondLevelTitleWidth:CGFloat = (self.bounds.width - ( margin * 2)) / 6
        let titleElementHeight:CGFloat = 40
        
        var state = "Victory"
        if myCS < opponentCS
        {
            state = "Loss"
        }
        else if myCS == opponentCS && myPoints < opponentPoints
        {
            state = "Loss"
        }
        
        var myStateLabel = UILabel(frame: CGRectMake(margin , 0, secondLevelTitleWidth, titleElementHeight))
        myStateLabel.textAlignment = NSTextAlignment.Center
        myStateLabel.text = "\(state)"
        myStateLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(myStateLabel)
        
        var myScoreCorrectSequenceLabel = UILabel(frame: CGRectMake(myStateLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        myScoreCorrectSequenceLabel.textAlignment = NSTextAlignment.Center
        myScoreCorrectSequenceLabel.text = "\(myCS)"
        myScoreCorrectSequenceLabel.numberOfLines = 2
        myScoreCorrectSequenceLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(myScoreCorrectSequenceLabel)
        
        var myScorePointsLabel = UILabel(frame: CGRectMake(myScoreCorrectSequenceLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        myScorePointsLabel.textAlignment = NSTextAlignment.Center
        myScorePointsLabel.text = "\(myPoints)"
        myScorePointsLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(myScorePointsLabel)
        
        
        
        var opponentNameLabel = UILabel(frame: CGRectMake(myScorePointsLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        opponentNameLabel.textAlignment = NSTextAlignment.Center
        opponentNameLabel.text = "\(opponentName)"
        opponentNameLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(opponentNameLabel)
        
        var opponentScoreCorrectSequenceLabel = UILabel(frame: CGRectMake(opponentNameLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        opponentScoreCorrectSequenceLabel.textAlignment = NSTextAlignment.Center
        opponentScoreCorrectSequenceLabel.text = "\(opponentCS)"
        opponentScoreCorrectSequenceLabel.numberOfLines = 2
        opponentScoreCorrectSequenceLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(opponentScoreCorrectSequenceLabel)
        
        var opponentScorePointsLabel = UILabel(frame: CGRectMake(opponentScoreCorrectSequenceLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        opponentScorePointsLabel.textAlignment = NSTextAlignment.Center
        opponentScorePointsLabel.text = "\(opponentPoints)"
        opponentScorePointsLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(opponentScorePointsLabel)
    }
}