//
//  PlayViewController.swift
//  PlaceInTime
//
//  Created by knut on 12/08/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import UIKit
import iAd

class PlayViewController:UIViewController,  DropZoneProtocol, ClockProtocol, ADBannerViewDelegate
{
    var gameStats:GameStats!
    var cardsStack:[Card] = []
    var backOfCard:UIImageView!
    let datactrl = DataHandler()
    var dropZones:[Int:DropZone] = [:]
    
    var infoHelperView:InfoHelperView!
    var clock:ClockView!
    var orgClockCenter:CGPoint!


    var originalDropZoneYCenter:CGFloat!
    var numberOfDropZones:Int = 3
    var maxNumDropZones:Int = 6
    var minNumDropZones:Int = 3
    
    var rightButton:UIButton!
    
    var cardToDrag:Card? = nil
    var newRevealedCard:Card? = nil
    let marginFromGamestats:CGFloat = 10
    var levelHigh:Int = 1
    var levelLow:Int = 1
    var tags:[String] = []
    var gametype:gameType!
    let backButton = UIButton()
    var usersIdsToChallenge:[String] = []
    var completedQuestionsIds:[[String]] = []
    var numOfQuestionsForRound:Int = 3
    var myIdAndName:(String,String)!
    
    var challenge:Challenge!
    
    var bannerView:ADBannerView?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        datactrl.fetchData(tags: tags,fromLevel:levelLow,toLevel: levelHigh)
        
        self.canDisplayBannerAds = true
        bannerView = ADBannerView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 44, UIScreen.mainScreen().bounds.size.width, 44))
        self.view.addSubview(bannerView!)
        self.bannerView?.delegate = self
        self.bannerView?.hidden = false
        
        gameStats = GameStats(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width * 0.75, UIScreen.mainScreen().bounds.size.height * 0.08),okScore: 0,goodScore: 0,loveScore: 0)
        self.view.addSubview(gameStats)
        
        clock = ClockView(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width * 0.75, 10, gameStats.frame.height * 1.5, gameStats.frame.height * 1.5))
        orgClockCenter = CGPointMake(marginFromGamestats + gameStats.frame.maxX + (self.clock.frame.width / 2),self.marginFromGamestats + (self.clock.frame.height / 2))
        clock.delegate = self
        

        
        addDropZone()

        let rightButtonWidth = UIScreen.mainScreen().bounds.size.width * 0.55
        rightButton = UIButton(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width - rightButtonWidth) / 2, gameStats.frame.maxY + marginFromGamestats, rightButtonWidth, UIScreen.mainScreen().bounds.size.height * 0.25))
        rightButton.setTitle("OK 👍\nRight sequence", forState: UIControlState.Normal)
        rightButton.backgroundColor = UIColor.blueColor()
        rightButton.addTarget(self, action: "okAction", forControlEvents: UIControlEvents.TouchUpInside)
        rightButton.layer.cornerRadius = 5
        rightButton.layer.masksToBounds = true
        rightButton.alpha = 0
        view.addSubview(rightButton)
        
        infoHelperView = InfoHelperView(frame: CGRectMake(10, gameStats.frame.maxY + marginFromGamestats, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height * 0.4))
        infoHelperView.alpha = 0
        view.addSubview(infoHelperView)
        if self.gametype == gameType.training
        {
            let backButtonMargin:CGFloat = 15
            backButton.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width - smallButtonSide - backButtonMargin, backButtonMargin, smallButtonSide, smallButtonSide)
            backButton.backgroundColor = UIColor.whiteColor()
            backButton.layer.borderColor = UIColor.grayColor().CGColor
            backButton.layer.borderWidth = 1
            backButton.layer.cornerRadius = 5
            backButton.layer.masksToBounds = true
            backButton.setTitle("🔚", forState: UIControlState.Normal)
            backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(backButton)
        }
        self.view.addSubview(clock)
    }
    
    override func viewDidAppear(animated: Bool) {
        bannerView?.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 44, UIScreen.mainScreen().bounds.size.width, 44)
        setCardStack()
        //revealNextCard()
    }
    
    var touchOverride:Bool = false
    func timeup()
    {
        //ensure touch is enabled
        touchOverride = true
        
        var allCardsPlaced = true
        for item in dropZones
        {
            if item.1.getHookedUpCard() == nil
            {
                allCardsPlaced = false
                break
            }
        }
        if allCardsPlaced
        {
            okAction()
        }
        else
        {
            
            animateTimeout()
        }
    }
    
    func animateTimeout()
    {
        view.bringSubviewToFront(clock)
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            self.clock.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
            
            }, completion: { (value: Bool) in
                
                self.rightButton.userInteractionEnabled = false
                
                var label = UILabel(frame: CGRectMake(0, 0, 100, 40))
                label.textAlignment = NSTextAlignment.Center
                label.font = UIFont.boldSystemFontOfSize(20)
                label.adjustsFontSizeToFitWidth = true
                label.backgroundColor = UIColor.clearColor()
                label.text = "Time is up"
                label.alpha = 1
                label.center = self.clock.center
                label.transform = CGAffineTransformScale(label.transform, 0.1, 0.1)
                self.view.addSubview(label)
                
                UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    
                    self.clock.transform = CGAffineTransformScale(self.clock.transform, 6, 6)
                    
                    label.transform = CGAffineTransformIdentity
                    
                    }, completion: { (value: Bool) in
                        
                        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                            
                            self.clock.alpha = 0
                            label.alpha = 0
                            
                            }, completion: { (value: Bool) in
                                label.removeFromSuperview()
                                
                                self.fails = self.numberOfDropZones
                                self.animateCleanupAndStartNewRound()
                        })
                })
        })
        
    }

    func setCardStack()
    {
        for item in cardsStack
        {
            item.removeFromSuperview()
        }

        if gametype == gameType.takingChallenge
        {
            randomHistoricEvents = datactrl.fetchHistoricEventOnIds(challenge.getNextQuestionBlock())!

        }
        else
        {
            //DONT shuffle, if will mess up the used sorting
            //datactrl.shuffleEvents()
            randomHistoricEvents = datactrl.getRandomHistoricEventsWithPrecision(25, numEvents:numberOfDropZones)
        }
        
        for historicEvent in randomHistoricEvents
        {
            historicEvent.used++
        }
        datactrl.save()

        animateNewCardInCardStack(0)
    }
    
    var randomHistoricEvents:[HistoricEvent] = []

    
    func animateNewCardInCardStack(var i:Int)
    {
        
        let orgCardWidth:CGFloat = 314
        let orgCardHeight:CGFloat = 226
        let cardWidthToHeightRatio:CGFloat =   orgCardHeight / orgCardWidth


        let cardWidth:CGFloat = orgCardWidth / 2.5
        let cardHeight:CGFloat = orgCardHeight / 2.5
        
        //let frame = CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (cardWidth / 2) + xOffset,gameStats.frame.maxY + marginFromGamestats + yOffset, cardWidth, cardHeight)
        let card = Card(frame:CGRectMake(-100, gameStats.frame.maxY + marginFromGamestats, cardWidth, cardHeight),event:randomHistoricEvents[i])
        
        cardsStack.append(card)
        self.view.addSubview(card)
        
        
        
        var yOffset:CGFloat = getRandomOffset()
        var xOffset:CGFloat = getRandomOffset()
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in

            card.center = CGPointMake((UIScreen.mainScreen().bounds.size.width / 2) + xOffset, self.gameStats.frame.maxY + self.marginFromGamestats + yOffset + (cardHeight / 2))
            
            card.transform = CGAffineTransformRotate(card.transform, self.getRandomRotation())
            
            }, completion: { (value: Bool) in
                i++
                
                if i < self.numberOfDropZones
                {
                    self.animateNewCardInCardStack(i)
                }
                else
                {
                    self.revealNextCard()
                    self.view.bringSubviewToFront(self.infoHelperView)
                    self.view.bringSubviewToFront(self.clock)
                }
        })
    }
    
    func getRandomRotation() -> CGFloat
    {
        var randomNum = Int(arc4random_uniform(UInt32(5)))
        if randomNum == 0
        {
            return -0.05
        }
        else if randomNum == 1
        {
            return -0.025
        }
        else if randomNum == 2
        {
            return 0
        }
        else if randomNum == 3
        {
            return 0.025
        }
        else
        {
            return 0.05
        }
    }
    
    func getRandomOffset() -> CGFloat
    {
        var randomNum = Int(arc4random_uniform(UInt32(3)))
        if randomNum == 0
        {
            return 1.5
        }
        else if randomNum == 1
        {
            return 1.8
        }
        else
        {
            return 2.1
        }
    }
    
    var tempViews:[UIView] = []
    var tempYearLabel:[UILabel] = []
    var fails:Int = 0
    func okAction()
    {
        clock.stop()
        rightButton.userInteractionEnabled = false
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.rightButton.alpha = 0
            
            //self.clock.frame.offset(dx: 200, dy: 0)
            self.clock.transform = CGAffineTransformScale(self.clock.transform, 0.1, 0.1)
            self.clock.alpha = 0
            }, completion: { (value: Bool) in
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    
                    
                    for var i = 0 ; i <  self.dropZones.count ; i++
                    {
                        self.dropZones[i]!.center = CGPointMake(self.dropZones[i]!.center.x, UIScreen.mainScreen().bounds.size.height / 2)
                        self.dropZones[i]!.getHookedUpCard()?.center = self.dropZones[i]!.center
                    }
                    
                    
                    }, completion: { (value: Bool) in
                        self.animateYears(0, completion: {() -> Void in
                            self.fails = 0
                            self.animateResult(0)
                        })
                })
        })
    }
    
    func animateYears(var i:Int,completion: (() -> (Void)))
    {
        var label = UILabel(frame: dropZones[i]!.frame)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(20)
        label.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        label.text = dropZones[i]?.getHookedUpCard()?.event.formattedTime
        label.alpha = 0
        view.addSubview(label)
        tempYearLabel.append(label)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            
            label.frame.offset(dx: 0, dy: label.frame.size.height * -1)
            label.transform = CGAffineTransformScale(label.transform, 1.3, 1.3)
            label.alpha = 1
            }, completion: { (value: Bool) in
                i++
                if i < self.dropZones.count
                {
                    self.animateYears(i,completion: completion)
                }
                else
                {
                    completion()
                }
        })
        
    }
    
    func animateResult(index:Int, lastYear:Int32? = nil, var dragOverlabel:UILabel? = nil)
    {
        let dropZone = dropZones[index]
        var label = tempYearLabel[index]
        
        if dragOverlabel == nil && index > 0
        {
            dragOverlabel = UILabel(frame: tempYearLabel[0].frame)
            dragOverlabel!.textAlignment = NSTextAlignment.Center
            dragOverlabel!.font = UIFont.boldSystemFontOfSize(20)
            dragOverlabel!.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
            view.addSubview(dragOverlabel!)
            tempViews.append(dragOverlabel!)
        }
        dragOverlabel?.text = dropZone?.getHookedUpCard()?.event.formattedTime
        dragOverlabel?.alpha = 1
        
        
        var thisYear = dropZone?.getHookedUpCard()?.event.fromYear
        var wrongAnswer = false
        if thisYear != nil && index > 0
        {
            if thisYear < lastYear
            {
                fails++
                wrongAnswer = true
                thisYear = lastYear
            }
        }

            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                    dragOverlabel?.center = label.center
                    dragOverlabel?.alpha = 0.5
                
                }, completion: { (value: Bool) in
                    dragOverlabel?.alpha = 0
                    if index > 0
                    {
                        if wrongAnswer == false
                        {
                            label.textColor = UIColor.greenColor()
                            
                            var pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity")
                            pulseAnimation.duration = 0.3
                            pulseAnimation.toValue = NSNumber(float: 0.3)
                            pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                            pulseAnimation.autoreverses = true
                            pulseAnimation.repeatCount = 5
                            pulseAnimation.delegate = self
                            label.layer.addAnimation(pulseAnimation, forKey: "key\(index)")

                            //animate right points
                            self.animatePoints(label.center)
                        }
                        else
                        {
                            UIView.animateWithDuration(0.25, animations: { () -> Void in

                                    self.dropZones[index]?.frame.offset(dx: 0, dy: self.dropZones[index]!.frame.height / 2)
                                    //self.dropZones[index]?.getHookedUpCard()!.frame.offset(dx: 0, dy: self.dropZones[index]!.frame.height / 2)
                                    self.dropZones[index]!.getHookedUpCard()!.center = self.dropZones[index]!.center
                                
                                    label.textColor = UIColor.redColor()
                                    label.frame.offset(dx: 0, dy: (label.frame.size.height / 2) )
                                    label.transform = CGAffineTransformScale(label.transform, 0.75, 0.75)
                                    label.text = "\(label.text!)\(self.getFailsEmoji(self.fails))"

                                }, completion: { (value: Bool) in
                            })
                            
                        }
                    }
                    
                    
                    if index < (self.dropZones.count - 1)
                    {
                        self.animateResult(index + 1, lastYear: thisYear,dragOverlabel: dragOverlabel)
                    }
                    else
                    {
                        self.animateCleanupAndStartNewRound()
                    }
                })

    }
    
    func getFailsEmoji(fails:Int) -> String
    {
        //😕😞😦😫😭😲
        if fails < 2
        {
            return "😕"
        }
        else if fails < 3
        {
            return "😞"
        }
        else if fails < 4
        {
            return "😦"
        }
        else if fails < 5
        {
            return "😫"
        }
        else if fails < 6
        {
            return "😭"
        }
        else
        {
            return "😲"
        }
    }
    
    func animateCleanupAndStartNewRound()
    {
        var tapViewForNextRound = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        tapViewForNextRound.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.01)
        tapViewForNextRound.alpha = 0
        tempViews.append(tapViewForNextRound)
        view.addSubview(tapViewForNextRound)
        
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in

            tapViewForNextRound.alpha = 1
            
            }, completion: { (value: Bool) in
                
                let tapGesture = UITapGestureRecognizer(target: self, action: "tapForNextRound")
                tapGesture.numberOfTapsRequired = 1
                tapViewForNextRound.addGestureRecognizer(tapGesture)
                self.tapOverride = true
        })
    }
    
    var tapOverride = false
    func tapForNextRound()
    {
        touchOverride = false
        self.cleanUpTempLabelsForAnimation()


        if fails == 0
        {
            numberOfDropZones = numberOfDropZones >= maxNumDropZones ? numberOfDropZones : numberOfDropZones + 1
            self.animateCorrectSequence()
        }
        else
        {
            numberOfDropZones = numberOfDropZones >= minNumDropZones ? numberOfDropZones : numberOfDropZones - 1
            self.nextRound()
        }
        
    }
    
    func animateCorrectSequence()
    {
        var points = 1 //1 * (numberOfDropZones - (minNumDropZones - 1))
        

        
        var label = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(24)
        label.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        label.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        label.text = "Totally correct \(points)😍"
        label.alpha = 0
        view.addSubview(label)
        
        for dropzone in self.dropZones
        {
            dropzone.1.getHookedUpCard()?.layer.borderColor = UIColor.greenColor().CGColor
            if let card = dropzone.1.getHookedUpCard()
            {
                card.layer.borderWidth = 2
                card.layer.borderColor = UIColor.greenColor().CGColor
                
                var pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity")
                pulseAnimation.duration = 0.3
                pulseAnimation.toValue = NSNumber(float: 0.3)
                pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                pulseAnimation.autoreverses = true
                pulseAnimation.repeatCount = 5
                pulseAnimation.delegate = self
                card.layer.addAnimation(pulseAnimation, forKey: "key\(index)")
            }
            
            
        }
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            //label.center = self.gameStats.lovePoints.center
            label.transform = CGAffineTransformScale(label.transform, 2, 2)
            label.alpha = 1

            }, completion: { (value: Bool) in
                
                UIView.animateWithDuration(1, animations: { () -> Void in
                    label.center = self.gameStats.lovePointsView.center
                    label.transform = CGAffineTransformIdentity
                    label.transform = CGAffineTransformScale(label.transform, 0.1, 0.1)
                    label.alpha = 0
                    }, completion: { (value: Bool) in

                        self.gameStats.addLovePoints(points)
                        //self.datactrl.updateLoveScore(self.currentQuestion, deltaScore:points)
                        label.removeFromSuperview()
                        self.nextRound()
                })
        })
        

    }
    
    func cleanUpTempLabelsForAnimation()
    {
        for item in self.tempViews
        {
            item.removeFromSuperview()
        }
        self.tempViews = []
        for item in self.tempYearLabel
        {
            item.removeFromSuperview()
        }
        self.tempYearLabel = []
    }
    
    func nextRound()
    {
        //move stuff away
        animateRemoveElementsAtRoundEnd({() -> Void in
            for var i = 0 ;  i < self.dropZones.count ; i++
            {
                self.dropZones[i]?.removeFromSuperview()
            }
        
            var roundQuestionIds:[String] = []
            for item in self.randomHistoricEvents
            {
                roundQuestionIds.append("\(item.idForUpdate)")
            }
            self.completedQuestionsIds.append(roundQuestionIds)
            
            if (self.gametype != gameType.training) && (self.completedQuestionsIds.count >= self.numOfQuestionsForRound)
            {
                self.performSegueWithIdentifier("segueFromPlayToFinished", sender: nil)
            }
            else
            {
                self.dropZones = [:]
                self.addDropZone()
                self.setCardStack()
                //self.revealNextCard()
                self.rightButton.userInteractionEnabled = true
                self.tapOverride = false
            }
        
        })

    }
    
    func animateRemoveElementsAtRoundEnd(completion: (() -> (Void)))
    {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.infoHelperView.alpha = 0
            self.rightButton.alpha = 0
            }, completion: { (value: Bool) in
                self.animateRemoveOneDropzoneWithCard(0,completion: {() -> Void in

                    self.animateRemoveOneCardFromCardStack(comp: {() -> Void in
                        completion()
                    })

                })
        })

    }
    
    func animateRemoveOneCardFromCardStack(comp: (() -> (Void))? = nil)
    {
        //TODO: awful code. make closure

        if let card = self.cardToDrag
        {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                //card.frame.offset(dx: -500, dy: 0)
                card.center = CGPointMake(0 - card.frame.width, card.center.y)
                
                }, completion: { (value: Bool) in
                    self.cardToDrag = nil
                    card.removeFromSuperview()
                    self.animateRemoveOneCardFromCardStack(comp: comp)
            })
        }
        else if let card = self.newRevealedCard
        {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                card.frame.offset(dx: -500, dy: 0)
                
                }, completion: { (value: Bool) in
                    self.newRevealedCard = nil
                    card.removeFromSuperview()
                    self.animateRemoveOneCardFromCardStack(comp: comp)
            })
        }
        else if cardsStack.count > 0
        {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                var card = self.cardsStack.last
                card?.frame.offset(dx: -500, dy: 0)
                
                }, completion: { (value: Bool) in
                    self.cardsStack.removeLast()
                    if let card = self.newRevealedCard
                    {
                        card.removeFromSuperview()
                    }

                    self.animateRemoveOneCardFromCardStack(comp: comp)

            })
        }
        else
        {
            comp!()
        }
    }
    
    func animateRemoveOneDropzoneWithCard(var i:Int, completion: (() -> (Void))? = nil)
    {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.dropZones[i]?.center = CGPointMake(0 - self.dropZones[i]!.frame.width, self.dropZones[i]!.center.y )
                self.dropZones[i]?.getHookedUpCard()?.center = CGPointMake(0 - self.dropZones[i]!.frame.width, self.dropZones[i]!.getHookedUpCard()!.center.y )
                
                
                }, completion: { (value: Bool) in
                    self.dropZones[i]?.getHookedUpCard()?.removeFromSuperview()
                    if i < self.dropZones.count
                    {
                        i++
                        self.animateRemoveOneDropzoneWithCard(i,completion: completion)
                    }
                    else
                    {
                        completion!()
                    }
            })
    }
    

    
    func animatePoints(centerPoint:CGPoint)
    {
        var points = 10 * (numberOfDropZones - (minNumDropZones - 1))
        var label = UILabel(frame: dropZones[0]!.frame)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.boldSystemFontOfSize(20)
        label.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        label.center = centerPoint
        label.text = "\(points)😌"
        label.alpha = 0
        view.addSubview(label)
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            label.center = self.gameStats.okPointsView.center
            label.transform = CGAffineTransformScale(label.transform, 1.2, 1.2)
            label.alpha = 1
            }, completion: { (value: Bool) in

                label.alpha = 0
                self.gameStats.addOkPoints(points)
                //self.datactrl.updateOkScore(self.currentQuestion, deltaScore:points)
                label.removeFromSuperview()
        })
        
    }
    
    func revealNextCard()
    {
        if let card = cardsStack.last
        {
            view.bringSubviewToFront(card)
            card.tap()
            cardsStack.removeLast()
            newRevealedCard = card
        }
    }

    
    func addDropZone()
    {
        let orgCardWidth:CGFloat = 314
        let orgCardHeight:CGFloat = 226
        let cardWidthToHeightRatio:CGFloat =   orgCardHeight / orgCardWidth
        let margin:CGFloat = 2
        
        let devidingFactor:CGFloat = numberOfDropZones < 4 ? 4 : CGFloat(numberOfDropZones)
        
        let dropZoneWidth = (UIScreen.mainScreen().bounds.size.width - (margin * (devidingFactor + 1))) / devidingFactor
        let dropZoneHeight = dropZoneWidth * cardWidthToHeightRatio
        var xOffset = margin
        var key = dropZones.count
        originalDropZoneYCenter = UIScreen.mainScreen().bounds.size.height - (dropZoneHeight / 2)
        
        let dropZone = DropZone(frame: CGRectMake(xOffset,UIScreen.mainScreen().bounds.size.height - dropZoneHeight , dropZoneWidth, dropZoneHeight),key:key)

        dropZone.delegate = self
        
        view.addSubview(dropZone)
        //view.addSubview(dropZone.focusDisplayView)
        
        dropZones.updateValue(dropZone, forKey: key)
        //xOffset += (margin + dropZoneWidth)
        
        
        //adjust placement of dropzones
        var xCenter = (UIScreen.mainScreen().bounds.size.width / 2) - ((CGFloat(dropZones.count - 1) * (dropZone.frame.width + margin)) / 2)
        
        
        for var i = 0 ;  i < dropZones.count ; i++
        {
            //println(" KEY \(dropZones[i]!.key)")
            dropZones[i]!.center = CGPointMake(xCenter, UIScreen.mainScreen().bounds.size.height - dropZones[i]!.frame.height)
            if let card = dropZones[i]!.getHookedUpCard()
            {
                card.center = dropZones[i]!.center
            }
            xCenter += (margin + dropZoneWidth)
        }

    }
    
    
    func gettingFocus(sender:DropZone)
    {
        
        let fullFocusY = UIScreen.mainScreen().bounds.size.height - (sender.frame.height * 2)
        let halfFocusY = UIScreen.mainScreen().bounds.size.height - (sender.frame.height * 1.5)
        let orgY = sender.center.y
        
        
        UIView.animateWithDuration(0.15, animations: { () -> Void in

            for item in self.dropZones
            {
                if let card = item.1.getHookedUpCard()
                {
                    card.transform = CGAffineTransformIdentity
                    //card.transform = CGAffineTransformScale(card.transform, 0.7, 0.7)
                    if item.1 == sender
                    {
                        
                        card.center = CGPointMake(card.center.x, fullFocusY)
                        //card.transform = CGAffineTransformScale(card.transform, 1.5,  1.5)
                    }
                    else if item.0 == (sender.key - 1) //left
                    {
                        
                        card.center = CGPointMake(card.center.x, halfFocusY)
                        card.transform = CGAffineTransformRotate(card.transform, -0.2)
                        //card.transform = CGAffineTransformScale(card.transform, 1.5,  1.5)
                    }
                    else if item.0 == (sender.key + 1) // right
                    {
                        
                        card.center = CGPointMake(card.center.x, halfFocusY)
                        card.transform = CGAffineTransformRotate(item.1.transform, 0.2)
                        //card.transform = CGAffineTransformScale(item.1.transform, 1.5,  1.5)
                    }
                    else
                    {
                        card.center = CGPointMake(card.center.x, orgY)
                    }
                }
            }
            }, completion: { (value: Bool) in
                
        })
    }
    
    
    private var xOffset: CGFloat = 0.0
    private var yOffset: CGFloat = 0.0

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if tapOverride || touchOverride
        {
            return
        }
        self.rightButton.alpha = 0
        var touch = touches.first as? UITouch
        var touchLocation = touch!.locationInView(self.view)
        
        if let card = cardToDrag
        {
            
            //reset focus
            for item in dropZones
            {
                item.1.removeFocus()
            }


            var isInnView = CGRectContainsPoint(cardToDrag!.frame,touchLocation)
            if(isInnView)
            {

                if card.dragging == false
                {
                    card.dragging = true
                    card.center = touchLocation
                    UIView.animateWithDuration(0.25, animations: { () -> Void in
                        //card.transform = CGAffineTransformScale(card.transform, 0.75,  0.75)
                        
                        
                        }, completion: { (value: Bool) in
                            //card.transform = CGAffineTransformScale(card.transform, 0.75,  0.75)
                            
                    })
                }
                
                let point = (touches.first as? UITouch)!.locationInView(self.view) //touches.anyObject()!.locationInView(self.view)
                xOffset = point.x - card.center.x
                yOffset = point.y - card.center.y
                //pointLabel.transform = CGAffineTransformMakeRotation(10.0 * CGFloat(Float(M_PI)) / 180.0)
            }
        }
        else if newRevealedCard != nil && CGRectContainsPoint(newRevealedCard!.frame,touchLocation)
        {
            cardToDrag = newRevealedCard
            self.newRevealedCard = nil
        }
        else
        {
            for var i = 0 ; i < dropZones.count ; i++
            {
                if let card = dropZones[i]?.getHookedUpCard()
                {
                    if CGRectContainsPoint(card.frame,touchLocation)
                    {
                        cardToDrag = card
                        dropZones[i]?.setHookedUpCard(nil)
                        view.bringSubviewToFront(cardToDrag!)
                        CGRectContainsPoint(cardToDrag!.frame,touchLocation)
                        break
                    }
                }
                
            }
        }
        
        
        
        
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if touchOverride
        {
            return
        }
        
        if let card = cardToDrag
        {
            var touch = touches.first as? UITouch //touches.anyObject()
            var touchLocation = touch!.locationInView(self.view)
            var isInnView = CGRectContainsPoint(card.frame,touchLocation)
            
            if(isInnView)
            {
                let dropZone = focusToDropZone(touchLocation)

                if dropZone?.getHookedUpCard() != nil
                {

                    var isInnView = CGRectContainsPoint(self.cardToDrag!.frame,touchLocation)
                    if(isInnView)
                    {
                         UIView.animateWithDuration(0.15, animations: { () -> Void in
                                self.makeRoomForCard( dropZone!, touchLocation: touchLocation)
                            
                            }, completion: { (value: Bool) in
                                //self.makeRoomForCard( dropZone!, touchLocation: touchLocation)
                        })
                    }
                }
                
                let point = (touches.first as? UITouch)!.locationInView(self.view) //touches.anyObject()!.locationInView(self.view)
                card.center = CGPointMake(point.x - xOffset, point.y - yOffset)
            }
        }
    }
    
    func focusToDropZone(touchLocation:CGPoint) -> DropZone?
    {
        var dropZoneToGiveFocus:DropZone?
        for item in dropZones
        {
            if CGRectContainsPoint(item.1.frame,touchLocation)
            {
                dropZoneToGiveFocus =  item.1
            }
            else
            {
               item.1.removeFocus()
            }
        }
        if let dropzone = dropZoneToGiveFocus
        {
            dropzone.giveFocus()
        }
        return dropZoneToGiveFocus
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
      
        if touchOverride
        {
            return
        }
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in

           self.infoHelperView.alpha = 0
            if let card = self.cardToDrag
            {
                
                var touch = touches.first as? UITouch //touches.anyObject()
                var touchLocation = touch!.locationInView(self.view)
                
                //self.directionLabel.alpha = 0
                
                if let dropzone = self.getFocusDropZone()
                {
                    var isInnView = CGRectContainsPoint(self.cardToDrag!.frame,touchLocation)
                    if(isInnView)
                    {
                        self.dropCardInZone(card, dropzone: dropzone, touchLocation: touchLocation)
                        if self.dropZones.count < self.numberOfDropZones
                        {
                            
                            //first card placed
                            if self.cardsStack.count  == (self.numberOfDropZones - 1)
                            {
                                self.clock.start()
                                self.clock.center = self.orgClockCenter
                                self.clock.transform = CGAffineTransformIdentity
                                self.clock.alpha = 1
                            }
                            
                            if self.newRevealedCard == nil
                            {
                                self.addDropZone()
                                self.revealNextCard()
                            }
                        }
                        else
                        {
                            self.rightButton.alpha = 1
                        }
                        //self.revealedCard = nil
                    }
                }
            }
            
            }, completion: { (value: Bool) in

        })

    }

    
    func dropCardInZone(card:Card, dropzone:DropZone,touchLocation:CGPoint)
    {
        let dropzoneWidth:CGFloat = dropzone.frame.width
        let draggingCardWidth:CGFloat = cardToDrag!.frame.width
        let scale = dropzoneWidth / draggingCardWidth
        card.transform = CGAffineTransformScale(card.transform, scale, scale)

        if dropzone.getHookedUpCard() == nil
        {
            self.cardToDrag = nil
            dropzone.setHookedUpCard(card)
        }

         self.cardToDrag = nil
    }
    
    func makeRoomForCard(dropzone:DropZone,touchLocation:CGPoint)
    {

        if self.mostFreeSlotAtBack(dropzone)
        {
            self.pushBackwardAndMakeSpace(self.dropZones[dropzone.key]!)
            
            var textLeft:String? = dropZones[dropzone.key - 1]?.getHookedUpCard()?.event.title
            var textMid = cardToDrag!.event.title
            var textRight:String? = dropZones[dropzone.key + 1]?.getHookedUpCard()?.event.title
            infoHelperView.setText(textLeft, main:textMid , right: textRight)
            
            
        }
        else
        {
            self.pushForwardAndMakeSpace(self.dropZones[dropzone.key]!)
            
            var textLeft:String? = dropZones[dropzone.key - 1]?.getHookedUpCard()?.event.title
            var textMid = cardToDrag!.event.title
            var textRight:String? = dropZones[dropzone.key + 1]?.getHookedUpCard()?.event.title
            infoHelperView.setText(textLeft, main:textMid , right: textRight)
            
        }
        //view.bringSubviewToFront(infoHelperView)
        infoHelperView.alpha = 1

    }
    
    func pushForwardAndMakeSpace(dropzone:DropZone)
    {
        if let cardToPass = dropzone.getHookedUpCard()
        {
            passCardForwardAndHookupNew(dropZones[dropzone.key! + 1], newCardToHookup: cardToPass)
        }
        dropzone.setHookedUpCard(nil)
    }
    
    func pushBackwardAndMakeSpace(dropzone:DropZone)
    {
        if let cardToPass = dropzone.getHookedUpCard()
        {
            passCardBackwardAndHookupNew(dropZones[dropzone.key! - 1], newCardToHookup: cardToPass)
        }
        dropzone.setHookedUpCard(nil)
    }
    
    func passCardBackwardAndHookupNew(dropZone:DropZone?, newCardToHookup:Card)
    {
        if let drop = dropZone
        {
            let hookedUpCardToPass = drop.getHookedUpCard()
            drop.setHookedUpCard(newCardToHookup)
            //_?drop.hookedUpCard!.center = drop.center
            if let cardToPass = hookedUpCardToPass
            {
                passCardBackwardAndHookupNew(dropZones[drop.key! - 1]!,newCardToHookup: cardToPass)
            }
        }
    }
    
    func passCardForwardAndHookupNew(dropZone:DropZone?, newCardToHookup:Card)
    {
        if let drop = dropZone
        {
            let hookedUpCardToPass = drop.getHookedUpCard()
            drop.setHookedUpCard(newCardToHookup)
            //_?drop.hookedUpCard!.center = drop.center
            if let cardToPass = hookedUpCardToPass
            {
                passCardForwardAndHookupNew(dropZones[drop.key! + 1]!,newCardToHookup: cardToPass)
            }
        }
    }


    
    
    func mostFreeSlotAtBack(dropzone:DropZone) -> Bool
    {
        var countBack = 0
        var countFront = 0
        for var indexKey = dropzone.key! ; indexKey >= 0 ; indexKey--
        {
            if dropZones[indexKey]?.getHookedUpCard() == nil
            {
                countBack++
            }
        }
        for var indexKey = dropzone.key! ; indexKey < dropZones.count ; indexKey++
        {
            if dropZones[indexKey]?.getHookedUpCard() == nil
            {
                countFront++
            }
        }
        return countBack > countFront
    }

    
    func getFocusDropZone() -> DropZone?
    {
        for item in dropZones
        {
            if item.1.focus
            {
                return item.1
            }
        }
        return nil
    }
    
    func backAction()
    {
        //datactrl.saveGameData()
        self.performSegueWithIdentifier("segueFromPlayToMainMenu", sender: nil)
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueFromPlayToMainMenu") {
            var svc = segue!.destinationViewController as! MainMenuViewController
            if gameStats.newValues()
            {
                svc.updateGlobalGameStats = true
                svc.newGameStatsValues = (gameStats.okPoints!,gameStats.goodPoints!,gameStats.lovePoints)
                //svc.imagefile = currentImagefile
            }
        }
        if (segue.identifier == "segueFromPlayToFinished") {
            var svc = segue!.destinationViewController as! FinishedViewController
            svc.completedQuestionsIds = completedQuestionsIds
            svc.usersIdsToChallenge = usersIdsToChallenge
            svc.userFbId = myIdAndName.0
            svc.correctAnswers = gameStats.lovePoints
            svc.points = gameStats.okPoints
            svc.gametype = gametype
            if gametype == gameType.takingChallenge
            {
                svc.challengeToBeat = challenge
            }
            else if gametype == gameType.makingChallenge
            {
                svc.challengeName = "\(self.myIdAndName.1) \(self.levelLow)-\(self.levelHigh) \(self.tagsAsString())"
            }
        }
    }
    
    func tagsAsString() -> String
    {
        var result = ""
        for item in tags
        {
            result += item
        }
        if result == ""
        {
            result = "All categories"
        }
        return result
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.bannerView?.hidden = false
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return willLeave
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.bannerView?.hidden = true
    }
    
}