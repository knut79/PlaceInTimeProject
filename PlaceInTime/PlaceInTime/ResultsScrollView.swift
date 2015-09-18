//
//  ResultsScrollView.swift
//  PlaceInTime
//
//  Created by knut on 17/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation


class ResultsScrollView: UIView , UIScrollViewDelegate{
    
    var items:[ResultItemView]!
    var scrollView:UIScrollView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let itemheight:CGFloat = 40

        
        let margin:CGFloat = 0
        let topLevelTitleWidth:CGFloat = (self.bounds.width - (margin * 2)) / 2
        let titleElementHeight:CGFloat = 40
        
        var myScoreLabel = ResultTitleLabel(frame: CGRectMake(margin , margin, topLevelTitleWidth, titleElementHeight))
        myScoreLabel.textAlignment = NSTextAlignment.Center
        myScoreLabel.text = "My score"
        myScoreLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(myScoreLabel)
        
        
        var opponentsScoreLabel = ResultTitleLabel(frame: CGRectMake(myScoreLabel.frame.maxX , margin, topLevelTitleWidth, titleElementHeight))
        opponentsScoreLabel.textAlignment = NSTextAlignment.Center
        opponentsScoreLabel.text = "Opponent score"
        opponentsScoreLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(opponentsScoreLabel)
        
        let secondLevelTitleWidth:CGFloat = (self.bounds.width - ( margin * 2)) / 6
        
        var myStateLabel = ResultTitleLabel(frame: CGRectMake(margin , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        myStateLabel.textAlignment = NSTextAlignment.Center
        myStateLabel.text = "Result"
        myStateLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(myStateLabel)
        
        var myScoreCorrectSequenceLabel = ResultTitleLabel(frame: CGRectMake(myStateLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        myScoreCorrectSequenceLabel.textAlignment = NSTextAlignment.Center
        myScoreCorrectSequenceLabel.text = "Correct\nsequence"
        myScoreCorrectSequenceLabel.numberOfLines = 2
        myScoreCorrectSequenceLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(myScoreCorrectSequenceLabel)
        
        var myScorePointsLabel = ResultTitleLabel(frame: CGRectMake(myScoreCorrectSequenceLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        myScorePointsLabel.textAlignment = NSTextAlignment.Center
        myScorePointsLabel.text = "Points"
        myScorePointsLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(myScorePointsLabel)
        
        
        
        var opponentNameLabel = ResultTitleLabel(frame: CGRectMake(myScorePointsLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        opponentNameLabel.textAlignment = NSTextAlignment.Center
        opponentNameLabel.text = "Name"
        opponentNameLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(opponentNameLabel)
        
        var opponentScoreCorrectSequenceLabel = ResultTitleLabel(frame: CGRectMake(opponentNameLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        opponentScoreCorrectSequenceLabel.textAlignment = NSTextAlignment.Center
        opponentScoreCorrectSequenceLabel.text = "Correct\nsequence"
        opponentScoreCorrectSequenceLabel.numberOfLines = 2
        opponentScoreCorrectSequenceLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(opponentScoreCorrectSequenceLabel)
        
        var opponentScorePointsLabel = ResultTitleLabel(frame: CGRectMake(opponentScoreCorrectSequenceLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        opponentScorePointsLabel.textAlignment = NSTextAlignment.Center
        opponentScorePointsLabel.text = "Points"
        opponentScorePointsLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(opponentScorePointsLabel)
        
        
        
        
        var totalResultLabel = UILabel(frame: CGRectMake(margin ,self.bounds.height - titleElementHeight , topLevelTitleWidth, titleElementHeight))
        totalResultLabel.textAlignment = NSTextAlignment.Center
        totalResultLabel.text = "Victories 3 Losses 1 :)"
        //opponentScorePointsLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(totalResultLabel)
        
        
        
        
        scrollView = UIScrollView(frame: CGRectMake(0, opponentScorePointsLabel.frame.maxY, self.bounds.width, self.bounds.height - opponentScorePointsLabel.frame.maxY - totalResultLabel.frame.height))
        
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderWidth = 5.0
        

        items = []
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, 0)
        
        self.addSubview(scrollView)
        
    }
    
    func initValues( )
    {
        let itemheight:CGFloat = 40
        
    }
    
    func addItem(myCS:Int,myPoints:Int,opponentName:String,opponentCS:Int,opponentPoints:Int)
    {
        let itemheight:CGFloat = 40
        var contentHeight:CGFloat = 0
        
        let newItem = ResultItemView(frame: CGRectMake(0, 0, self.frame.width, itemheight), myCS: myCS,myPoints:myPoints,opponentName:opponentName,opponentCS:opponentCS,opponentPoints:opponentPoints)
        items.insert(newItem, atIndex: 0)
        scrollView.addSubview(newItem)
        
        contentHeight = newItem.frame.maxY
        var itemsChecked = 0
        var i:CGFloat = 0
        for item in items
        {
            item.frame = CGRectMake(0, itemheight * i, self.frame.width, itemheight)
            contentHeight = item.frame.maxY
            i++
        }
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, contentHeight)
    }
    
}