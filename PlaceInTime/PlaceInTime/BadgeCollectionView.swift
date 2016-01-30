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

        
        //let badgesOnOneRow:CGFloat = 4
        let badgesOnColumn:CGFloat = 3
        let marginBetweenBadges:CGFloat = 5
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


        
        //TEST
        let challengeQuestionBlocksIds = datactrl.fetchQuestionsForBadgeChallenge(1,numCardsInBlock: 3,filter: ["sport"],fromLevel: 1,toLevel: 3)
        
        
        sportBadge1 = BadgeView(frame: CGRectMake(marginRightLeft, marginTopBottom, badgeWidth, badgeHeight), title: "Sports first class", image: "sportsBadge1.png")
        sportBadge1.delegate = self
        sportBadge1.setQuestions(challengeQuestionBlocksIds)
        self.addSubview(sportBadge1)
        var lastXPos = sportBadge1.frame.maxX
        
        if let badge = sportBadge1 where badge.complete
        {
            sportBadge2 = BadgeView(frame: CGRectMake(lastXPos - onTopMargin, marginTopBottom, badgeWidth, badgeHeight), title: "Sports second class", image: "sportsBadge2.png")
            sportBadge2!.delegate = self
            sportBadge2!.setQuestions(challengeQuestionBlocksIds)
            self.addSubview(sportBadge2!)
            lastXPos = sportBadge2!.frame.maxX
        }
        
        if let badge = sportBadge2 where badge.complete
        {
            sportBadge3 = BadgeView(frame: CGRectMake(lastXPos - onTopMargin, marginTopBottom, badgeWidth, badgeHeight), title: "Sports third class", image: "sportsBadge3.png",hints:3)
            sportBadge3!.delegate = self
            sportBadge3!.setQuestions(challengeQuestionBlocksIds)
            self.addSubview(sportBadge3!)
            lastXPos = sportBadge3!.frame.maxX
        }
        
        
        scienceBadge1 = BadgeView(frame: CGRectMake(lastXPos + marginTopBottom, marginTopBottom, badgeWidth, badgeHeight),title: "Science first class", image: "scienceBadge1.png")
        scienceBadge1!.delegate = self
        scienceBadge1!.setQuestions(challengeQuestionBlocksIds)
        self.addSubview(scienceBadge1!)
        lastXPos = scienceBadge1!.frame.maxX

        if let badge = scienceBadge1 where badge.complete
        {
            scienceBadge2 = BadgeView(frame: CGRectMake(lastXPos - onTopMargin, marginTopBottom, badgeWidth, badgeHeight),title: "Science second class", image: "scienceBadge2.png")
            scienceBadge2!.delegate = self
            scienceBadge2!.setQuestions(challengeQuestionBlocksIds)
            self.addSubview(scienceBadge2!)
            lastXPos = scienceBadge2!.frame.maxX
        }
        

        if let badge = scienceBadge2 where badge.complete
        {
            scienceBadge3 = BadgeView(frame: CGRectMake(lastXPos - onTopMargin, marginTopBottom, badgeWidth, badgeHeight),title: "Science third class", image: "scienceBadge3.png")
            scienceBadge3!.delegate = self
            scienceBadge3!.setQuestions(challengeQuestionBlocksIds)
            self.addSubview(scienceBadge3!)
            lastXPos = scienceBadge3!.frame.maxX
        }
        
        if let badge = scienceBadge3 where badge.complete
        {
            scienceBadge4 = BadgeView(frame: CGRectMake(lastXPos - onTopMargin, marginTopBottom, badgeWidth, badgeHeight),title: "Science fourth class", image: "scienceBadge4.png")
            scienceBadge4!.delegate = self
            scienceBadge4!.setQuestions(challengeQuestionBlocksIds)
            self.addSubview(scienceBadge4!)
            lastXPos = scienceBadge4!.frame.maxX
        }
        

        if let badge1 = scienceBadge1, badge2 = sportBadge1 where badge1.complete && badge2.complete
        {
            headOfState1 = BadgeView(frame: CGRectMake(lastXPos + marginTopBottom, marginTopBottom, badgeWidth, badgeHeight),title: "Head of state first class", image: "leadersBadge1.png")
            headOfState1!.delegate = self
            headOfState1!.setQuestions(challengeQuestionBlocksIds)
            self.addSubview(headOfState1!)
            lastXPos = headOfState1!.frame.maxX
        }

        if let badge = headOfState1 where badge.complete
        {
            headOfState2 = BadgeView(frame: CGRectMake(lastXPos - onTopMargin, marginTopBottom, badgeWidth, badgeHeight),title: "Head of state second class", image: "leadersBadge2.png")
            headOfState2!.delegate = self
            headOfState2!.setQuestions(challengeQuestionBlocksIds)
            self.addSubview(headOfState2!)
            lastXPos = headOfState2!.frame.maxX
        }
        
        if let badge1 = headOfState1, badge2 = scienceBadge2 where badge1.complete && badge2.complete
        {
            warBadge1 = BadgeView(frame: CGRectMake(lastXPos + marginTopBottom, marginTopBottom, badgeWidth, badgeHeight),title: "Wars first class", image: "warBadge1.png")
            warBadge1!.delegate = self
            warBadge1!.setQuestions(challengeQuestionBlocksIds)
            self.addSubview(warBadge1!)
            lastXPos = warBadge1!.frame.maxX
        }

        if let badge = warBadge1 where badge.complete
        {
            warBadge2 = BadgeView(frame: CGRectMake(lastXPos - onTopMargin, marginTopBottom, badgeWidth, badgeHeight),title: "Wars second class", image: "warBadge2.png")
            warBadge2!.delegate = self
            warBadge2!.setQuestions(challengeQuestionBlocksIds)
            self.addSubview(warBadge2!)
        }
    }

    
    func setBadgeChallenge(badgeChallenge:BadgeChallenge)
    {
        currentBadgeChallenge = badgeChallenge
        delegate?.playBadgeChallengeAction()
        
    }
    
}