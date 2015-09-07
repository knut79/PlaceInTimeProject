//
//  TagCheckScrollview.swift
//  TimeIt
//
//  Created by knut on 06/08/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit
//◻️◼️
//⚪️🔘
//◽️🔳

protocol CheckViewProtocol
{
    func closeCheckView()
    func reloadMarks(tags:[String])
    
}

class CheckScrollView: UIView , UIScrollViewDelegate, CheckItemProtocol{
    
    var checkItems:[CheckItemView]!
    var tags:[String]!
    var scrollView:UIScrollView!
    var closeButton:UIButton!
    var delegate:CheckViewProtocol!
    var selectedInfoLabel:UILabel!
    var itemName:String!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init(frame: CGRect, initialValues:[String] = [], itemsName:String = "item") {
        super.init(frame: frame)
        tags = []
        checkItems = []
        
        self.itemName = itemsName
        
        closeButton = UIButton(frame: CGRectMake(frame.width - 40, 0, 40, 40))
        closeButton.setTitle("❌", forState: UIControlState.Normal)
        closeButton.addTarget(self, action: "closeAction", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.layer.borderColor = UIColor.blackColor().CGColor
        closeButton.layer.borderWidth = 2.0
        
        
        scrollView = UIScrollView(frame: CGRectMake(0, closeButton.frame.height, frame.width, frame.height - closeButton.frame.height))
        
        scrollView.delegate = self
        self.addSubview(scrollView)
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 2.0
        
        for item in initialValues
        {
            tags.append(item)
        }
        
        /*
        tags.append("#war")
        tags.append("#headOfState")
        tags.append("#science")
        tags.append("#discovery")
        tags.append("#invention")
        tags.append("#sport")
        tags.append("#miscellaneous")
        */
        
        let itemheight:CGFloat = 40
        
        selectedInfoLabel = UILabel(frame: CGRectMake(0, 0, self.frame.width - closeButton.frame.width, itemheight))
        selectedInfoLabel.textAlignment = NSTextAlignment.Center
        selectedInfoLabel.text = "\(tags.count) \(itemName)s selected"

        
        var contentHeight:CGFloat = 0
        var i:CGFloat = 0
        for tagItem in tags
        {
            let newTagCheckItem = CheckItemView(frame: CGRectMake(0, itemheight * i, self.frame.width, itemheight), tagTitle: tagItem)
            newTagCheckItem.delegate = self
            checkItems.append(newTagCheckItem)
            scrollView.addSubview(newTagCheckItem)
            contentHeight = newTagCheckItem.frame.maxY
            i++
        }
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, contentHeight)
        self.addSubview(selectedInfoLabel)
        self.addSubview(closeButton)
        
    }
    
    func unselectAllItem()
    {
        for item in checkItems
        {
            item.checked = false
            item.checkBoxView.setTitle("◽️", forState: UIControlState.Normal)
        }
        delegate.reloadMarks(getItemsAsArray())
    }
    
    func checkChanged()
    {
        let selectedTags = getItemsAsArray()
        delegate.reloadMarks(selectedTags)
        
        selectedInfoLabel.text = "\(selectedTags.count) \(itemName)s selected"
    }
    
    func getItemsAsArray() -> [String]
    {
        var returnValue:[String] = []
        for item in checkItems
        {
            if item.checked
            {
                returnValue.append(item.title)
            }
        }
        return returnValue
    }
    
    
    func closeAction()
    {
        let selectedTags = getItemsAsArray()
        delegate.reloadMarks(selectedTags)
        
        selectedInfoLabel.text = "\(selectedTags.count) \(itemName)s selected"
        delegate!.closeCheckView()
        
    }
}
