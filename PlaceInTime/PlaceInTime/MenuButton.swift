//
//  MenuButton.swift
//  MapFeud
//
//  Created by knut on 28/10/15.
//  Copyright © 2015 knut. All rights reserved.
//

import Foundation
import UIKit

class MenuButton:UIButton {
    
    var label:UILabel!
    var badgeLabel:UILabel!
    var borderView:UIView!
    var orgCenter:CGPoint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, title:String) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        
        let borderMargin = frame.height * 0.05
        borderView = UIView(frame: CGRectMake(borderMargin, borderMargin, frame.width - (borderMargin * 2), frame.height * 0.9))
        borderView.backgroundColor = UIColor.clearColor()
        borderView.layer.cornerRadius = 5
        borderView.layer.masksToBounds = true
        borderView.layer.borderColor = UIColor.blueColor().CGColor
        borderView.layer.borderWidth = 2
        borderView.userInteractionEnabled = false
        self.addSubview(borderView)
        
        
        let margin = frame.height * 0.1
        label = UILabel(frame: CGRectMake(margin, margin, frame.width - (margin * 2), frame.height * 0.8))
        label.text = title
        label.textAlignment = NSTextAlignment.Center
        //label.layer.borderColor = UIColor.lightGrayColor().CGColor
        label.backgroundColor = UIColor.blueColor()
        label.textColor = UIColor.whiteColor()
        label.layer.cornerRadius = 3 //label.bounds.size.width / 2
        label.layer.masksToBounds = true
        self.addSubview(label)
        
        //let hints = NSUserDefaults.standardUserDefaults().integerForKey("hintsLeftOnAccount")
        let badgeLabelSide = label.frame.height * 0.6
        badgeLabel = UILabel(frame: CGRectMake(frame.width - badgeLabelSide, frame.height - badgeLabelSide ,badgeLabelSide, badgeLabelSide))
        badgeLabel.text = "3"
        badgeLabel.adjustsFontSizeToFitWidth = true
        badgeLabel.textAlignment = NSTextAlignment.Center
        //label.layer.borderColor = UIColor.lightGrayColor().CGColor
        badgeLabel.backgroundColor = UIColor.redColor()
        badgeLabel.textColor = UIColor.whiteColor()
        badgeLabel.layer.cornerRadius = badgeLabelSide / 2
        badgeLabel.layer.borderWidth = 2
        badgeLabel.layer.borderColor = UIColor.blueColor().CGColor
        badgeLabel.layer.masksToBounds = true
        badgeLabel.alpha = 0
        self.addSubview(badgeLabel)
        
    }
    
    func setbadge(badge:Int)
    {
        if badge > 0
        {
            badgeLabel.alpha = 1
            badgeLabel.text = "\(badge)"
        }
        else
        {
            badgeLabel.alpha = 0
        }
        
    }
    
    
}