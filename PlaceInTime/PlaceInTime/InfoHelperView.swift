//
//  InfoHelperView.swift
//  PlaceInTime
//
//  Created by knut on 28/08/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit

class InfoHelperView: UIView {
    
    var infoLabelLeft:UILabel!
    var infoLabelMain:UILabel!
    var infoLabelRight:UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(1)
        
        infoLabelLeft = UILabel(frame: CGRectMake(0, 0, self.bounds.width * 0.45, self.bounds.height / 2 ))
        infoLabelLeft.textAlignment = NSTextAlignment.Center
        infoLabelLeft.transform = CGAffineTransformScale(infoLabelLeft.transform, 0.7, 0.7)
        infoLabelLeft.center = CGPointMake(self.bounds.width * 0.25, self.bounds.height * 0.75)
        infoLabelLeft.alpha = 0.75
        
        infoLabelMain = UILabel(frame: CGRectMake(0, 0, self.bounds.width * 0.80, self.bounds.height / 2))
        infoLabelMain.textAlignment = NSTextAlignment.Center
        infoLabelMain.center = CGPointMake(self.bounds.width / 2, self.bounds.height * 0.25)
        
        infoLabelRight = UILabel(frame: CGRectMake(0, 0, self.bounds.width * 0.45, self.bounds.height / 2))
        infoLabelRight.textAlignment = NSTextAlignment.Center
        infoLabelRight.transform = CGAffineTransformScale(infoLabelRight.transform, 0.7, 0.7)
        infoLabelRight.center = CGPointMake(self.bounds.width * 0.75, self.bounds.height * 0.75)
        infoLabelRight.alpha = 0.75
        
        self.addSubview(infoLabelLeft)
        self.addSubview(infoLabelMain)
        self.addSubview(infoLabelRight)
    }
    
    func setText(left:String?,main:String,right:String?)
    {
        infoLabelLeft.text = left ?? ""
        infoLabelMain.text = main
        infoLabelRight.text = right ?? ""
    }
}
