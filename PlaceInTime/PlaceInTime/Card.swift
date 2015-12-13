//
//  Card.swift
//  PlaceInTime
//
//  Created by knut on 14/08/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit


class Card: UIView
{
    //var yearTitle: UILabel!
    var textTitle: UILabel!
    var back:UIImageView!
    var dragging:Bool = false
    var event:HistoricEvent!
    
    
    var testHint:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame:CGRect, event:HistoricEvent){
        super.init(frame: frame)


        self.event = event
        
        self.backgroundColor = UIColor.grayColor()
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 1
        
        self.contentMode = UIViewContentMode.ScaleToFill
        self.clipsToBounds = false
        
        let hintHeight = self.frame.height * 0.17
        let hintWidth = self.frame.width * 0.35
        testHint = UILabel(frame: CGRectMake(self.frame.width / 2, self.frame.height,hintWidth,hintHeight))
        testHint.clipsToBounds = false
        testHint.textAlignment = NSTextAlignment.Center
        testHint.layer.cornerRadius = 3
        testHint.backgroundColor = UIColor.blackColor()
        testHint.layer.borderColor = UIColor.blackColor().CGColor
        testHint.layer.borderWidth = 1
        testHint.textColor = UIColor.whiteColor()
        testHint.text = "\(event.toYear)"
        testHint.alpha = 0
        testHint.transform = CGAffineTransformScale(testHint.transform, 0.1, 0.1)
        self.addSubview(testHint)

        
        /*
        yearTitle = UILabel(frame: CGRectMake(0, 0, frame.width, frame.height * 0.2))
        yearTitle.textAlignment = NSTextAlignment.Center
        yearTitle.text = "\(event.fromYear)"
        */
        
        //let textTitleMargin:CGFloat = 3
        
        textTitle = UILabel(frame: CGRectMake(frame.width * 0.1, frame.height * 0.1, frame.width * 0.8, frame.height * 0.8))
        textTitle.textAlignment = NSTextAlignment.Left
        textTitle.numberOfLines = 6
        textTitle.adjustsFontSizeToFitWidth = true
        textTitle.text = event.title

        let backImage = UIImage(named: "back.png")
        
        back = UIImageView(image: imageResize(backImage!,sizeChange: CGSizeMake(frame.width,frame.height)))
        back.layer.cornerRadius = 5
        back.layer.masksToBounds = true
        back.userInteractionEnabled = true
        /*
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapCard:")
        tapGesture.numberOfTapsRequired = 1
        back.addGestureRecognizer(tapGesture)
        */
        self.addSubview(back)

    }
    
    /*
    func tapCard(sender:UIGestureRecognizer)
    {
        UIView.transitionWithView(self, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, animations: { () -> Void in
            self.back.hidden = true
            
            self.addSubview(self.yearTitle)
            self.addSubview(self.textTitle)
            
            }, completion: { (value: Bool) in
                self.back.removeGestureRecognizer(sender)
    
        })
    }
*/
    
    func setHint()
    {
        UIView.animateWithDuration(0.5, animations: { () -> Void in

            self.testHint.transform = CGAffineTransformIdentity
            self.testHint.alpha = 1
            //self.testHint.alpha = 0
            //self.testHint.transform = CGAffineTransformScale(self.testHint.transform, 0.1, 0.1)
            }, completion: { (value: Bool) in

        })
    }
    

    
    func tap()
    {
        UIView.transitionWithView(self, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromRight, animations: { () -> Void in
            self.back.hidden = true
            
            //self.addSubview(self.yearTitle)
            self.addSubview(self.textTitle)
            
            }, completion: { (value: Bool) in
        })
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