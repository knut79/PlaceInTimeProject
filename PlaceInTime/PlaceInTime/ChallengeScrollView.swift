//
//  ChallengeScrollView.swift
//  PlaceInTime
//
//  Created by knut on 14/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

//
//  UserScrollViewBackup.swift
//  PlaceInTime
//
//  Created by knut on 14/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

//
//  UsersScrollView.swift
//  PlaceInTime
//
//  Created by knut on 13/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

//
//  TagCheckScrollview.swift
//  TimeIt
//
//  Created by knut on 06/08/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit


protocol ChallengeViewProtocol
{
    func reloadMarks(tags:[String])
    
}

class ChallengeScrollView: UIView , UIScrollViewDelegate, RadiobuttonItemProtocol{
    
    var radiobuttonItems:[RadiobuttonItemView]!
    var items:[String:NSDictionary]!
    var scrollView:UIScrollView!
    
    var delegate:UserViewProtocol!
    var selectedInfoLabel:UILabel!
    var itemName:String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init(frame: CGRect, initialValues:[String:NSDictionary] = [:], itemsName:String = "item", itemsChecked:Bool = true) {
        super.init(frame: frame)
        
        let itemheight:CGFloat = 40
        selectedInfoLabel = UILabel(frame: CGRectMake(0, 0, self.bounds.width, itemheight))
        selectedInfoLabel.textAlignment = NSTextAlignment.Center
        
        scrollView = UIScrollView(frame: CGRectMake(0, selectedInfoLabel.frame.height, self.bounds.width, self.bounds.height - selectedInfoLabel.frame.height))
        
        scrollView.delegate = self
        
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 2.0
        
        items = initialValues
        radiobuttonItems = []
        
        self.itemName = itemsName
        
        var contentHeight:CGFloat = 0
        var i:CGFloat = 0
        for tagItem in items
        {
            let newTagCheckItem = RadiobuttonItemView(frame: CGRectMake(0, itemheight * i, self.frame.width, itemheight), title: tagItem.0, value:tagItem.1 ,checked:itemsChecked)
            newTagCheckItem.delegate = self
            radiobuttonItems.append(newTagCheckItem)
            scrollView.addSubview(newTagCheckItem)
            contentHeight = newTagCheckItem.frame.maxY
            i++
        }
        let numberOfItemSelected = itemsChecked ? items.count : 0
        selectedInfoLabel.text = "\(numberOfItemSelected) \(itemName)s selected"
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, contentHeight)
        
        self.addSubview(selectedInfoLabel)
        
        self.addSubview(scrollView)
        
    }
    
    func initValues( )
    {
        let itemheight:CGFloat = 40
        
    }
    
    
    func uncheckAll()
    {
        
        for item in radiobuttonItems
        {
            item.uncheck()
        }

    }
    
    func getItemsValueAsArray() -> [NSDictionary]
    {
        var returnValue:[NSDictionary] = []
        for item in radiobuttonItems
        {
            if item.checked
            {
                returnValue.append(item.value)
            }
        }
        return returnValue
    }
    
    
}
