//
//  BadgeView.swift
//  UsaFeud
//
//  Created by knut on 10/01/16.
//  Copyright © 2016 knut. All rights reserved.
//


import Foundation
import UIKit

protocol BadgeCollectionProtocol
{
    func playBadgeChallengeAction()
}

class BadgeCollectionView: UIView, BadgeChallengeProtocol {
    
    
    //var hintsLeftText:UILabel!
    
    // row 1

    
    var sportBadge1:BadgeView!
    var sportBadge2:BadgeView?
    var sportBadge3:BadgeView?
    
    var scienceBadge1:BadgeView?
    var scienceBadge2:BadgeView?
    var scienceBadge3:BadgeView?
    var scienceBadge4:BadgeView?

    var headOfState1:BadgeView?
    var headOfState2:BadgeView?
    
    var warBadge1:BadgeView?
    var warBadge2:BadgeView?
    
    var delegate:BadgeCollectionProtocol?
    
    let datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl
    
    var currentBadgeChallenge:BadgeChallenge?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func loadBadges()
    {
        let marginTopBottom:CGFloat = 6
        let marginRightLeft:CGFloat = 6
        
        let orgHeigth:CGFloat = 429
        let orgWidth:CGFloat = 370
        
        let badgeHeight = self.bounds.height - (marginTopBottom * 2)
        let heightToWidthRatio = orgHeigth / badgeHeight
        let badgeWidth = orgWidth / heightToWidthRatio
        //let badgeWidth = (self.bounds.width * 0.22) - (marginBetweenBadges * (badgesOnOneRow - 1)) - (marginTopBottom * 2)
        
        
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "mapAction:")
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.enabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        
        let onTopMargin:CGFloat = badgeWidth * 0.6
        
        sportBadge1 = BadgeView(frame: CGRectMake(marginRightLeft, marginTopBottom, badgeWidth, badgeHeight), title: "Sports first class", image: "sportsBadge1.png")
        if !sportBadge1!.complete
        {
            sportBadge1.delegate = self
            let blocksIds = datactrl.fetchQuestionsForBadgeChallenge(5,numCardsInBlock: 3,filter: ["sport"],fromLevel: 1,toLevel: 3)
            sportBadge1.setQuestions(blocksIds)
        }
        self.addSubview(sportBadge1)
        var lastXPos = sportBadge1.frame.maxX
        
        if let badge = sportBadge1 where badge.complete
        {
            sportBadge2 = BadgeView(frame: CGRectMake(lastXPos - onTopMargin, marginTopBottom, badgeWidth, badgeHeight), title: "Sports second class", image: "sportsBadge2.png",hints:3)
            if !sportBadge2!.complete
            {
                sportBadge2!.delegate = self
                let blocksIds = datactrl.fetchQuestionsForBadgeChallenge(5,numCardsInBlock: 4,filter: ["sport"],fromLevel: 1,toLevel: 3)
                sportBadge2!.setQuestions(blocksIds)
            }
            self.addSubview(sportBadge2!)
            lastXPos = sportBadge2!.frame.maxX
        }
        
        if let badge = sportBadge2 where badge.complete
        {
            sportBadge3 = BadgeView(frame: CGRectMake(lastXPos - onTopMargin, marginTopBottom, badgeWidth, badgeHeight), title: "Sports third class", image: "sportsBadge3.png",hints:4)
            if !sportBadge3!.complete
            {
                sportBadge3!.delegate = self
                let blocksIds = datactrl.fetchQuestionsForBadgeChallenge(5,numCardsInBlock: 5,filter: ["sport"],fromLevel: 1,toLevel: 3)
                sportBadge3!.setQuestions(blocksIds)
            }
            self.addSubview(sportBadge3!)
            lastXPos = sportBadge3!.frame.maxX
        }
        
        
        scienceBadge1 = BadgeView(frame: CGRectMake(lastXPos + marginTopBottom, marginTopBottom, badgeWidth, badgeHeight),title: "Science first class", image: "scienceBadge1.png")
        if !scienceBadge1!.complete
        {
            scienceBadge1!.delegate = self
            let blocksIds = datactrl.fetchQuestionsForBadgeChallenge(5,numCardsInBlock: 3,filter: ["science","discovery","invention"],fromLevel: 1,toLevel: 3)
            scienceBadge1!.setQuestions(blocksIds)
        }
        self.addSubview(scienceBadge1!)
        lastXPos = scienceBadge1!.frame.maxX
        
        if let badge = scienceBadge1 where badge.complete
        {
            scienceBadge2 = BadgeView(frame: CGRectMake(lastXPos - onTopMargin, marginTopBottom, badgeWidth, badgeHeight),title: "Science second class", image: "scienceBadge2.png",hints:3)
            if !scienceBadge2!.complete
            {
                scienceBadge2!.delegate = self
                let blocksIds = datactrl.fetchQuestionsForBadgeChallenge(5,numCardsInBlock: 4,filter: ["science","discovery","invention"],fromLevel: 1,toLevel: 3)
                scienceBadge2!.setQuestions(blocksIds)
            }
            self.addSubview(scienceBadge2!)
            lastXPos = scienceBadge2!.frame.maxX
        }
        
        
        if let badge = scienceBadge2 where badge.complete
        {
            scienceBadge3 = BadgeView(frame: CGRectMake(lastXPos - onTopMargin, marginTopBottom, badgeWidth, badgeHeight),title: "Science third class", image: "scienceBadge3.png",hints:4)
            if !scienceBadge3!.complete
            {
                scienceBadge3!.delegate = self
                let blocksIds = datactrl.fetchQuestionsForBadgeChallenge(5,numCardsInBlock: 5,filter: ["science","discovery","invention"],fromLevel: 1,toLevel: 3)
                scienceBadge3!.setQuestions(blocksIds)
            }
            self.addSubview(scienceBadge3!)
            lastXPos = scienceBadge3!.frame.maxX
        }
        
        if let badge = scienceBadge3 where badge.complete
        {
            scienceBadge4 = BadgeView(frame: CGRectMake(lastXPos - onTopMargin, marginTopBottom, badgeWidth, badgeHeight),title: "Science fourth class", image: "scienceBadge4.png",hints:6)
            if !scienceBadge4!.complete
            {
                scienceBadge4!.delegate = self
                let blocksIds = datactrl.fetchQuestionsForBadgeChallenge(5,numCardsInBlock: 6,filter: ["science","discovery","invention"],fromLevel: 1,toLevel: 3)
                scienceBadge4!.setQuestions(blocksIds)
            }
            self.addSubview(scienceBadge4!)
            lastXPos = scienceBadge4!.frame.maxX
        }
        
        
        if let badge1 = scienceBadge1, badge2 = sportBadge1 where badge1.complete && badge2.complete
        {
            headOfState1 = BadgeView(frame: CGRectMake(lastXPos + marginTopBottom, marginTopBottom, badgeWidth, badgeHeight),title: "Head of state first class", image: "leadersBadge1.png")
            if !headOfState1!.complete
            {
                headOfState1!.delegate = self
                let blocksIds = datactrl.fetchQuestionsForBadgeChallenge(5,numCardsInBlock: 3,filter: ["headOfState"],fromLevel: 1,toLevel: 3)
                headOfState1!.setQuestions(blocksIds)
            }
            self.addSubview(headOfState1!)
            lastXPos = headOfState1!.frame.maxX
        }
        
        if let badge = headOfState1 where badge.complete
        {
            headOfState2 = BadgeView(frame: CGRectMake(lastXPos - onTopMargin, marginTopBottom, badgeWidth, badgeHeight),title: "Head of state second class", image: "leadersBadge2.png",hints:3)
            if !headOfState2!.complete
            {
                headOfState2!.delegate = self
                let blocksIds = datactrl.fetchQuestionsForBadgeChallenge(5,numCardsInBlock: 4,filter: ["headOfState"],fromLevel: 1,toLevel: 3)
                headOfState2!.setQuestions(blocksIds)
            }
            self.addSubview(headOfState2!)
            lastXPos = headOfState2!.frame.maxX
        }
        
        if let badge1 = headOfState1, badge2 = scienceBadge2 where badge1.complete && badge2.complete
        {
            warBadge1 = BadgeView(frame: CGRectMake(lastXPos + marginTopBottom, marginTopBottom, badgeWidth, badgeHeight),title: "Wars first class", image: "warBadge1.png",hints:3)
            if !warBadge1!.complete
            {
                warBadge1!.delegate = self
                let blocksIds = datactrl.fetchQuestionsForBadgeChallenge(5,numCardsInBlock: 3,filter: ["war"],fromLevel: 1,toLevel: 3)
                warBadge1!.setQuestions(blocksIds)
            }
            self.addSubview(warBadge1!)
            lastXPos = warBadge1!.frame.maxX
        }
        
        if let badge = warBadge1 where badge.complete
        {
            warBadge2 = BadgeView(frame: CGRectMake(lastXPos - onTopMargin, marginTopBottom, badgeWidth, badgeHeight),title: "Wars second class", image: "warBadge2.png",hints:4)
            if !warBadge2!.complete
            {
                warBadge2!.delegate = self
                let blocksIds = datactrl.fetchQuestionsForBadgeChallenge(5,numCardsInBlock: 4,filter: ["war"],fromLevel: 1,toLevel: 3)
                warBadge2!.setQuestions(blocksIds)
            }
            self.addSubview(warBadge2!)
        }
    }

    
    func setBadgeChallenge(badgeChallenge:BadgeChallenge)
    {
        currentBadgeChallenge = badgeChallenge
        delegate?.playBadgeChallengeAction()
        
    }
    
}