//
//  DropZoneView.swift
//  PlaceInTime
//
//  Created by knut on 17/08/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit

protocol DropZoneProtocol
{
    func gettingFocus(sender:DropZone)
    
}

class DropZone: UIView {
    
    var focus:Bool = false
    //var focusDisplayView:UIView!
    var key:Int!
    var frontFocus:Bool = false
    var lastHookedUpCard:Card?
    private var hookedUpCard:Card?
    var delegate:DropZoneProtocol?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame:CGRect, key:Int){
        super.init(frame: frame)
        
        self.key = key

        //not added to this view!!!!
        /*
        focusDisplayView = UIView(frame: frame)
        focusDisplayView.backgroundColor = UIColor.grayColor()
        focusDisplayView.layer.cornerRadius = 5
        focusDisplayView.layer.masksToBounds = true
        
        focusDisplayView.layer.borderColor = UIColor.blackColor().CGColor
        focusDisplayView.layer.borderWidth = 1
        */
        
    }
    
    
    func setHookedUpCard(card:Card?)
    {
        lastHookedUpCard = hookedUpCard
        hookedUpCard = card
        if let card = hookedUpCard
        {
            card.center = self.center
        }
    }
    
    func resetHookedUpCard()
    {
        let tempCard = hookedUpCard
        hookedUpCard = lastHookedUpCard
        lastHookedUpCard = nil
        if let card = hookedUpCard
        {
            card.center = self.center
        }
    }
    
    func getHookedUpCard() -> Card?
    {
        return hookedUpCard
    }
    
    
    func giveFocus()
    {
        if focus == false
        {

            //delegate?.gettingFocus(self)

            
            
            //focusDisplayView.frame.offset(dx: 0, dy: focusDisplayView.frame.height * -1)
            self.alpha = 0.0
            //self.transform = CGAffineTransformScale(self.transform, 1.1, 1.1)
            focus = true
        }
    }
    
    func removeFocus()
    {
        if focus
        {
            //delegate?.loosingFocus(self)
            //focusDisplayView.frame = self.frame
            self.alpha = 1.0
            //self.transform = CGAffineTransformIdentity
            focus = false
        }
    }
    
    
}