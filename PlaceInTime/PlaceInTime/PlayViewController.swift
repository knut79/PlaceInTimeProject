//
//  PlayViewController.swift
//  PlaceInTime
//
//  Created by knut on 12/08/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import UIKit
import iAd

class PlayViewController:UIViewController, CardProtocol, DropZoneProtocol
{
    var gameStats:GameStats!
    var cards:[Card] = []
    var backOfCard:UIImageView!
    let datactrl = DataHandler()
    var dropZones:[Int:DropZone] = [:]
    var directionLabel:UILabel!
    var originalDropZoneYCenter:CGFloat!
    
    var tags:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

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
            
            let frame = CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (cardWidth / 2),gameStats.frame.maxY, cardWidth, cardHeight)
            let card = Card(frame:frame,event:item)
            card.delegate = self
            
            cards.append(card)
            i++
            if i > 4
            {
                break
            }
            else
            {
                //card.transform = CGAffineTransformScale(card.transform, 0.7, 0.7)
            }
        }
        
        let margin:CGFloat = 2
        let dropZoneWidth = (UIScreen.mainScreen().bounds.size.width - (margin * (CGFloat(cards.count) + 1))) / CGFloat(cards.count)
        let dropZoneHeight = dropZoneWidth * cardWidthToHeightRatio
        var xOffset = margin
        var key = 0
        originalDropZoneYCenter = UIScreen.mainScreen().bounds.size.height - (dropZoneHeight / 2)
        for item in cards
        {
            self.view.addSubview(item)
            
            let dropZone = DropZone(frame: CGRectMake(xOffset,UIScreen.mainScreen().bounds.size.height - dropZoneHeight , dropZoneWidth, dropZoneHeight),key:key)
            dropZone.layer.cornerRadius = 5
            dropZone.layer.masksToBounds = true
            
            dropZone.layer.borderColor = UIColor.blackColor().CGColor
            dropZone.layer.borderWidth = 1
            dropZone.delegate = self
            
            view.addSubview(dropZone)
            //view.addSubview(dropZone.focusDisplayView)
            
            dropZones.updateValue(dropZone, forKey: key)
            xOffset += (margin + dropZoneWidth)
            key++
        }
        self.view.addSubview(gameStats)
        
        directionLabel = UILabel(frame: CGRectMake(0, 0, 40, 40))
        directionLabel.text = "👇"
        directionLabel.textAlignment = NSTextAlignment.Center
        directionLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        directionLabel.alpha = 0
        self.view.addSubview(directionLabel)

    }
    
    var cardToDrag:Card? = nil
    func checkChanged(sender:Card)
    {
        cardToDrag = sender
        /*
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapToDrag")
        tapGesture.numberOfTapsRequired = 1
        sender.addGestureRecognizer(tapGesture)
        */

    }

    
    func gettingFocus(sender:DropZone)
    {
        
        let fullFocusY = UIScreen.mainScreen().bounds.size.height - (sender.frame.height * 2)
        let halfFocusY = UIScreen.mainScreen().bounds.size.height - (sender.frame.height * 1.5)
        let orgY = sender.center.y
        
        
        UIView.animateWithDuration(0.15, animations: { () -> Void in

            for item in self.dropZones
            {
                if let card = item.1.hookedUpCard
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
        if let card = cardToDrag
        {
            
            //reset focus
            for item in dropZones
            {
                item.1.removeFocus()
            }

            var touch = touches.first as? UITouch //touches.anyObject()
            var touchLocation = touch!.locationInView(self.view)
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

                if dropZone?.hookedUpCard == nil
                {
                    self.directionLabel.alpha = 0
                }
                else
                {
                    self.directionLabel.alpha = 1
                    self.directionLabel.transform = CGAffineTransformIdentity
                    if CGRectContainsPoint(CGRectMake(dropZone!.frame.origin.x, dropZone!.frame.origin.y, dropZone!.frame.width / 2, dropZone!.frame.height), touchLocation)
                    {
                        //front
                        self.directionLabel.transform = CGAffineTransformRotate(self.directionLabel.transform, -0.4)
                        self.directionLabel.center = CGPointMake(dropZone!.frame.minX - 10, dropZone!.frame.minY - 50)
                    }
                    else
                    {
                        //back
                        self.directionLabel.transform = CGAffineTransformRotate(self.directionLabel.transform, 0.4)
                        self.directionLabel.center = CGPointMake(dropZone!.frame.maxX + 10, dropZone!.frame.minY - 50)
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

            for item in self.dropZones
            {
                if let card = item.1.hookedUpCard
                {
                    card.center = CGPointMake(card.center.x, self.originalDropZoneYCenter)
                    card.transform = CGAffineTransformIdentity
                    //card.transform = CGAffineTransformScale(card.transform, 0.7, 0.7)
                    
                    let dropzoneWidth:CGFloat = item.1.frame.width
                    let draggingCardWidth:CGFloat = card.frame.width
                    let scale = dropzoneWidth / draggingCardWidth
                    card.transform = CGAffineTransformScale(card.transform, scale, scale)
                }
            }
            
            if let card = self.cardToDrag
            {
                
                var touch = touches.first as? UITouch //touches.anyObject()
                var touchLocation = touch!.locationInView(self.view)
                
                self.directionLabel.alpha = 0
                
                if let dropzone = self.getFocusDropZone()
                {
                    var isInnView = CGRectContainsPoint(self.cardToDrag!.frame,touchLocation)
                    if(isInnView)
                    {
                        self.dropCardInZone(card, dropzone: dropzone, touchLocation: touchLocation)
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

        if dropzone.hookedUpCard == nil
        {
            card.center = dropzone.center
            self.cardToDrag = nil
            dropzone.hookedUpCard = card
        }
        else
        {

            
            if CGRectContainsPoint(CGRectMake(dropzone.frame.origin.x, dropzone.frame.origin.y, dropzone.frame.width / 2, dropzone.frame.height), touchLocation)
            {
                //front
                println("--card should be put at back")
                if self.freeSlotAtBack(dropzone)
                {
                    self.pushBackwardAndPlaceNewCard(self.dropZones[dropzone.key - 1]!,card: card)
                    
                }
                else
                {
                    self.pushForwardAndPlaceNewCard(self.dropZones[dropzone.key - 1]!,card: card)
                }
            }
            else
            {
                //back
                println("--card should be put at front")
                if self.freeSlotAtFront(dropzone)
                {
                    self.pushForwardAndPlaceNewCard(self.dropZones[dropzone.key + 1]!,card: card)
                }
                else
                {
                    self.pushBackwardAndPlaceNewCard(self.dropZones[dropzone.key + 1]!,card: card)
                }
            }
            

        }
        
         self.cardToDrag = nil
    }
    
    func pushForwardAndPlaceNewCard(dropzone:DropZone, card:Card)
    {
        if dropzone.hookedUpCard != nil
        {
            for var indexKey = dropzone.key! ; indexKey < dropZones.count  ; indexKey++
            {
                println("-key is \(indexKey)")
                
                let jumpOf = dropZones[indexKey + 1]?.hookedUpCard == nil
                let cardToPass = dropZones[indexKey]?.hookedUpCard
                dropZones[indexKey + 1]?.hookedUpCard = cardToPass
                dropZones[indexKey + 1]?.hookedUpCard!.center = dropZones[indexKey + 1]!.center
                if jumpOf
                {
                    break
                }
                
            }
        }

        dropzone.hookedUpCard = card
        card.center = dropzone.center
    }
    
    func pushBackwardAndPlaceNewCard(dropzone:DropZone, card:Card)
    {
        if dropzone.hookedUpCard != nil
        {
            for var indexKey = dropzone.key! ; indexKey > 0  ; indexKey--
            {
                println("-key is \(indexKey)")

                let jumpOf = dropZones[indexKey - 1]?.hookedUpCard == nil
                let cardToPass = dropZones[indexKey]?.hookedUpCard
                dropZones[indexKey - 1]?.hookedUpCard = cardToPass
                dropZones[indexKey - 1]?.hookedUpCard!.center = dropZones[indexKey - 1]!.center
                if jumpOf
                {
                    break
                }

            }
        }
        dropzone.hookedUpCard = card
        card.center = dropzone.center
        
    }
    
    func freeSlotAtFront(dropzone:DropZone) -> Bool
    {
        for var indexKey = dropzone.key! ; indexKey < dropZones.count ; indexKey++
        {
            if dropZones[indexKey]?.hookedUpCard == nil
            {
                return true
            }
        }
        return false
    }
    
    func freeSlotAtBack(dropzone:DropZone) -> Bool
    {
        for var indexKey = dropzone.key! ; indexKey >= 0 ; indexKey--
        {
            if dropZones[indexKey]?.hookedUpCard == nil
            {
                return true
            }
        }
        return false
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