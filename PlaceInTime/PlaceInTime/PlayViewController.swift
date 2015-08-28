//
//  PlayViewController.swift
//  PlaceInTime
//
//  Created by knut on 12/08/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import UIKit
import iAd

class PlayViewController:UIViewController,  DropZoneProtocol
{
    var gameStats:GameStats!
    var cardsStack:[Card] = []
    var backOfCard:UIImageView!
    let datactrl = DataHandler()
    var dropZones:[Int:DropZone] = [:]
    
    var infoHelperView:InfoHelperView!


    var originalDropZoneYCenter:CGFloat!
    var maxDropZones:Int = 5
    var rightButton:UIButton!
    
    var cardToDrag:Card? = nil
    var newRevealedCard:Card? = nil
    
    var tags:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        let marginFromGamestats:CGFloat = 10
        datactrl.fetchData(fromLevel: 1, toLevel: 3)
        datactrl.shuffleEvents()
        gameStats = GameStats(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width * 0.75, UIScreen.mainScreen().bounds.size.height * 0.08),okScore: 0,goodScore: 0,loveScore: 0)
        
        
        var i = 0
        let orgCardWidth:CGFloat = 314
        let orgCardHeight:CGFloat = 226
        let cardWidthToHeightRatio:CGFloat =   orgCardHeight / orgCardWidth
        for item in datactrl.historicEventItems
        {
            let cardWidth:CGFloat = orgCardWidth / 2.5
            let cardHeight:CGFloat = orgCardHeight / 2.5
            
            let frame = CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (cardWidth / 2),gameStats.frame.maxY + marginFromGamestats, cardWidth, cardHeight)
            let card = Card(frame:frame,event:item)
            
            cardsStack.append(card)
            i++
            if i >= maxDropZones
            {
                break
            }

        }
        

        addDropZone()
        
        for item in cardsStack
        {
            self.view.addSubview(item)
        }
        self.view.addSubview(gameStats)
        
        
        let rightButtonWidth = UIScreen.mainScreen().bounds.size.width * 0.7
        rightButton = UIButton(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width - rightButtonWidth) / 2, gameStats.frame.maxY + marginFromGamestats, rightButtonWidth, UIScreen.mainScreen().bounds.size.height * 0.4))
        rightButton.setTitle("OK (this is the right sequence)", forState: UIControlState.Normal)
        rightButton.backgroundColor = UIColor.blueColor()
        rightButton.addTarget(self, action: "okAction", forControlEvents: UIControlEvents.TouchUpInside)
        rightButton.alpha = 0
        view.addSubview(rightButton)
        
        infoHelperView = InfoHelperView(frame: CGRectMake(10, gameStats.frame.maxY + marginFromGamestats, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height * 0.4))
        infoHelperView.alpha = 0
        view.addSubview(infoHelperView)
    }
    
    
    func okAction()
    {
        
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

    override func viewDidAppear(animated: Bool) {
        revealNextCard()
    }
    
    func addDropZone()
    {
        
        //_?
        let orgCardWidth:CGFloat = 314
        let orgCardHeight:CGFloat = 226
        let cardWidthToHeightRatio:CGFloat =   orgCardHeight / orgCardWidth
        
        let margin:CGFloat = 2
        let dropZoneWidth = (UIScreen.mainScreen().bounds.size.width - (margin * (CGFloat(maxDropZones) + 1))) / CGFloat(maxDropZones)
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
                        if self.dropZones.count < self.maxDropZones
                        {
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
        view.bringSubviewToFront(infoHelperView)
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
    
}