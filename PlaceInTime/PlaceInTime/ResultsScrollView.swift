//
//  ResultsScrollView.swift
//  PlaceInTime
//
//  Created by knut on 17/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation


class ResultsScrollView: UIView , UIScrollViewDelegate, UserFilterViewProtocol{
    
    var items:[ResultItemView]!
    var scrollView:UIScrollView!
    var totalResultLabel:UILabel!
    var userFilterScrollView:UserFilterScrollView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        let margin:CGFloat = 0
        let topLevelTitleWidth:CGFloat = (self.bounds.width - (margin * 2)) / 2
        let titleElementHeight:CGFloat = 40
        
        let myScoreLabel = ResultTitleLabel(frame: CGRectMake(margin , margin, topLevelTitleWidth, titleElementHeight))
        myScoreLabel.textAlignment = NSTextAlignment.Center
        myScoreLabel.text = "Me"

        
        self.addSubview(myScoreLabel)
        
        
        let opponentsScoreLabel = ResultTitleLabel(frame: CGRectMake(myScoreLabel.frame.maxX , margin, topLevelTitleWidth, titleElementHeight))
        opponentsScoreLabel.textAlignment = NSTextAlignment.Center
        opponentsScoreLabel.text = "    Opponent  +👆"
        opponentsScoreLabel.userInteractionEnabled = true
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapForOpponentFilter:")
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.enabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        opponentsScoreLabel.addGestureRecognizer(singleTapGestureRecognizer)
        self.addSubview(opponentsScoreLabel)
        
        let secondLevelTitleWidth:CGFloat = (self.bounds.width - ( margin * 2)) / 6
        
        let myStateLabel = ResultTitleLabel(frame: CGRectMake(margin , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        myStateLabel.textAlignment = NSTextAlignment.Center
        myStateLabel.text = "Result"
        self.addSubview(myStateLabel)
        
        let myScoreCorrectSequenceLabel = ResultTitleLabel(frame: CGRectMake(myStateLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        myScoreCorrectSequenceLabel.textAlignment = NSTextAlignment.Center
        myScoreCorrectSequenceLabel.text = "Bullseye"
        myScoreCorrectSequenceLabel.numberOfLines = 1
        self.addSubview(myScoreCorrectSequenceLabel)
        
        let myScorePointsLabel = ResultTitleLabel(frame: CGRectMake(myScoreCorrectSequenceLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        myScorePointsLabel.textAlignment = NSTextAlignment.Center
        myScorePointsLabel.text = "Points"
        self.addSubview(myScorePointsLabel)
        
        
        
        let opponentNameLabel = ResultTitleLabel(frame: CGRectMake(myScorePointsLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        opponentNameLabel.textAlignment = NSTextAlignment.Center
        opponentNameLabel.text = "Name"
        self.addSubview(opponentNameLabel)
        
        let opponentScoreCorrectSequenceLabel = ResultTitleLabel(frame: CGRectMake(opponentNameLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        opponentScoreCorrectSequenceLabel.textAlignment = NSTextAlignment.Center
        opponentScoreCorrectSequenceLabel.text = "Bullseye"
        opponentScoreCorrectSequenceLabel.numberOfLines = 1
        self.addSubview(opponentScoreCorrectSequenceLabel)
        
        let opponentScorePointsLabel = ResultTitleLabel(frame: CGRectMake(opponentScoreCorrectSequenceLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        opponentScorePointsLabel.textAlignment = NSTextAlignment.Center
        opponentScorePointsLabel.text = "Points"
        self.addSubview(opponentScorePointsLabel)
        
        
        
        
        totalResultLabel = UILabel(frame: CGRectMake(margin ,self.bounds.height - titleElementHeight , self.bounds.width, titleElementHeight))
        totalResultLabel.textAlignment = NSTextAlignment.Left
        
        totalResultLabel.text = "    Victories 0 Losses 0 😐"
        //totalResultLabel.layer.borderColor = UIColor.whiteColor().CGColor
        //totalResultLabel.layer.borderWidth = 2.0
        totalResultLabel.adjustsFontSizeToFitWidth = true
        totalResultLabel.backgroundColor = UIColor.blueColor()
        totalResultLabel.textColor = UIColor.whiteColor()
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

    
    func addItem(myCS:Int,myPoints:Int,opponentName:String,opponentId:String,opponentCS:Int,opponentPoints:Int, title:String, date:String, newRecord:Bool)
    {
        let itemheight:CGFloat = 40
        var contentHeight:CGFloat = 0
        
        let newItem = ResultItemView(frame: CGRectMake(0, 0, self.frame.width, itemheight), myCS: myCS,myPoints:myPoints,opponentName:opponentName,opponentId:opponentId,opponentCS:opponentCS,opponentPoints:opponentPoints, title:title, date:date,newRecord: newRecord)
        items.insert(newItem, atIndex: 0)
        scrollView.addSubview(newItem)
        
        contentHeight = newItem.frame.maxY
        var i:CGFloat = 0
        for item in items
        {
            item.frame = CGRectMake(0, itemheight * i, self.frame.width, itemheight)
            contentHeight = item.frame.maxY
            i++
        }
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, contentHeight)
    }
    
    
    func layoutResult(var index:Int, var numItemsLayedOut:Int = 0, var contentHeight:CGFloat = 0)
    {
        if items.count > index
        {
            let item = items[index]
            if filteredUsers.contains(item.opponentFullName)
            {
                item.frame = CGRectMake(0, item.frame.height * CGFloat(numItemsLayedOut), self.frame.width, item.frame.height)
                item.hidden = false
                contentHeight = item.frame.maxY
                numItemsLayedOut++
            }
            else
            {
                item.hidden = true
                
            }
            index++
            self.layoutResult(index,contentHeight: contentHeight,numItemsLayedOut:numItemsLayedOut)
            
        }
        else
        {
            scrollView.contentSize = CGSizeMake(scrollView.frame.width, contentHeight)
        }
    }
    
    func tapForOpponentFilter(gesture:UITapGestureRecognizer)
    {
        
        let rightLocation = userFilterScrollView.center
        userFilterScrollView.transform = CGAffineTransformScale(userFilterScrollView.transform, 0.1, 0.1)
        self.userFilterScrollView.alpha = 1
        userFilterScrollView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            
            self.userFilterScrollView.transform = CGAffineTransformIdentity
            
            self.userFilterScrollView.center = rightLocation
            }, completion: { (value: Bool) in
                self.userFilterScrollView.transform = CGAffineTransformIdentity
                self.userFilterScrollView.alpha = 1
                self.userFilterScrollView.center = rightLocation
                self.listClosed = false
        })
    }
    
    func setFilter(distinctUsers:[String])
    {
        filteredUsers = distinctUsers
        let margin:CGFloat = 10
        let scrollViewWidth = self.bounds.size.width - (margin * 2)
        userFilterScrollView = UserFilterScrollView(frame: CGRectMake((self.bounds.size.width / 2) - (scrollViewWidth / 2) , self.bounds.size.height * 0.2, scrollViewWidth, self.bounds.size.height / 1.3),initialValues:distinctUsers)
        userFilterScrollView.delegate = self
        
        userFilterScrollView.alpha = 0
        self.addSubview(userFilterScrollView!)
    }
    
    var listClosed = true
    var filteredUsers:[String]!
    func closeFilter(users:[String])
    {
        if listClosed
        {
            return
        }
        
        if users.count < 1
        {
            let alert = UIAlertView(title: "Pick 1", message: "Select at least 1 user", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            
        }
        else
        {
            filteredUsers = users
            let rightLocation = userFilterScrollView.center
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.userFilterScrollView.transform = CGAffineTransformScale(self.userFilterScrollView.transform, 0.1, 0.1)
                
                self.userFilterScrollView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
                }, completion: { (value: Bool) in
                    self.userFilterScrollView.transform = CGAffineTransformScale(self.userFilterScrollView.transform, 0.1, 0.1)
                    self.userFilterScrollView.alpha = 0
                    self.userFilterScrollView.center = rightLocation
                    self.listClosed = true
                    self.userFilterScrollView.alpha = 0
            })
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.layoutResult(0)
            })
            self.setResultText()
            
        }
    }
    
    func setResultText()
    {
        var wins:Int = 0
        var losses:Int = 0
        for item in items
        {
            if item.stateWin == 1
            {
                wins++
            }
            else if item.stateLoss == 1
            {
                losses++
            }
        }
        let icon:String = {
            if wins > 0 && losses == 0
            {
                return "😎"
            }
            else if wins > losses
            {
                return "😀"
            }
            else if losses > wins
            {
                return "😞"
            }
            else
            {
                return "😐"
            }
        }()
        totalResultLabel.text = "    Victories \(wins) Losses \(losses) \(icon)"
    }
    
}