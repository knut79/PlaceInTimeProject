//
//  ViewController.swift
//  TimeIt
//
//  Created by knut on 12/07/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import UIKit
import CoreGraphics
import QuartzCore
import iAd

class MainMenuViewController: UIViewController, TagCheckViewProtocol , ADBannerViewDelegate {
    
    
    var backgroundView:UIView!
    var playButton:UIButton!
    var playButtonExstraLabel:UILabel!
    var playButtonExstraLabel2:UILabel!
    var selectFilterTypeButton:UIButton!
    var loadingDataView:UIView!
    var loadingDataLabel:UILabel!
    var datactrl:DataHandler!
    var tagsScrollViewEnableBackground:UIView!
    var tagsScrollView:TagCheckScrollView!
    
    let queue = NSOperationQueue()
    
    var globalGameStats:GameStats!
    var updateGlobalGameStats:Bool = false
    var newGameStatsValues:(Int,Int,Int)!
    let levelSlider = RangeSlider(frame: CGRectZero)
    
    var tags:[String] = []
    
    
    var bannerView:ADBannerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datactrl = DataHandler()
        
        self.canDisplayBannerAds = true
        bannerView = ADBannerView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 44, UIScreen.mainScreen().bounds.size.width, 44))
        //bannerView = ADBannerView(frame: CGRectZero)
        self.view.addSubview(bannerView!)
        //self.bannerView?.delegate = self
        self.bannerView?.hidden = false
        
        // Do any additional setup after loading the view, typically from a nib.
        playButton = UIButton(frame:CGRectZero)
        playButton.addTarget(self, action: "playAction", forControlEvents: UIControlEvents.TouchUpInside)
        playButton.backgroundColor = UIColor.blueColor()
        playButton.setTitle("Play", forState: UIControlState.Normal)
        
        playButtonExstraLabel = UILabel(frame:CGRectZero)
        playButtonExstraLabel.backgroundColor = playButton.backgroundColor?.colorWithAlphaComponent(0)
        playButtonExstraLabel.textColor = UIColor.whiteColor()
        playButtonExstraLabel.font = UIFont.systemFontOfSize(12)
        playButtonExstraLabel.textAlignment = NSTextAlignment.Center
        playButton.addSubview(playButtonExstraLabel)
        
        playButtonExstraLabel2 = UILabel(frame:CGRectZero)
        playButtonExstraLabel2.backgroundColor = playButton.backgroundColor?.colorWithAlphaComponent(0)
        playButtonExstraLabel2.textColor = UIColor.whiteColor()
        playButtonExstraLabel2.font = UIFont.systemFontOfSize(12)
        playButtonExstraLabel2.textAlignment = NSTextAlignment.Center
        playButton.addSubview(playButtonExstraLabel2)

        levelSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        levelSlider.curvaceousness = 0.0
        levelSlider.maximumValue = Double(maxLevel) + 0.5
        levelSlider.minimumValue = Double(minLevel)
        levelSlider.typeValue = sliderType.bothLowerAndUpper
        view.addSubview(levelSlider)
        
        selectFilterTypeButton = UIButton(frame: CGRectZero)
        selectFilterTypeButton.setTitle("📋", forState: UIControlState.Normal)
        selectFilterTypeButton.addTarget(self, action: "openFilterList", forControlEvents: UIControlEvents.TouchUpInside)
        selectFilterTypeButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        view.addSubview(selectFilterTypeButton)
        
        
        if Int(datactrl.dataPopulatedID as! NSNumber) <= 0
        {
            loadingDataLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
            loadingDataLabel.text = "Loading data.."
            loadingDataLabel.textAlignment = NSTextAlignment.Center
            loadingDataView = UIView(frame: CGRectMake(50, 50, 200, 50))
            loadingDataView.backgroundColor = UIColor.redColor()
            loadingDataView.addSubview(loadingDataLabel)
            self.view.addSubview(loadingDataView)
            
            var pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity");
            pulseAnimation.duration = 0.3
            pulseAnimation.toValue = NSNumber(float: 0.3)
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            pulseAnimation.autoreverses = true
            pulseAnimation.repeatCount = 100
            pulseAnimation.delegate = self
            loadingDataView.layer.addAnimation(pulseAnimation, forKey: "asd")
        }
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if Int(datactrl.dataPopulatedID as! NSNumber) <= 0
        {
            
            DataHandler().populateData({ () in
                
                self.setupAfterPopulateData()

                self.loadingDataView.alpha = 0
                self.loadingDataView.layer.removeAllAnimations()
            })
            
            loadingDataView?.frame =  CGRectMake(50, 50, 200, 50)
        }
        else
        {
            setupAfterPopulateData()
        }
        
        if updateGlobalGameStats
        {
            globalGameStats.addOkPoints(newGameStatsValues.0, completion: { () in
                self.globalGameStats.addLovePoints(self.newGameStatsValues.2)
                
            })
            updateGlobalGameStats = false
            datactrl.updateGameData(newGameStatsValues.0,deltaGoodPoints: newGameStatsValues.1,deltaLovePoints: newGameStatsValues.2)
            datactrl.saveGameData()
        }
    }
    
    func setupAfterPopulateData()
    {
        self.view.addSubview(self.playButton)
        globalGameStats = GameStats(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width * 0.75, UIScreen.mainScreen().bounds.size.height * 0.08),okScore: Int(datactrl.okScoreID as! NSNumber),goodScore: Int(datactrl.goodScoreID as! NSNumber),loveScore: Int(datactrl.loveScoreID as! NSNumber))
        self.view.addSubview(globalGameStats)
        setupCheckboxView()
    }
    
    
    override func viewDidLayoutSubviews() {
        
        bannerView?.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 44, UIScreen.mainScreen().bounds.size.width, 44)
        
        loadingDataView?.frame =  CGRectMake(50, 50, 200, 50)
        
        
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        
        
        
        let orientation = UIDevice.currentDevice().orientation
        //var orientationText = orientation.isLandscape ? "landscape" : "portrait"
        
        var playbuttonWidth = UIScreen.mainScreen().bounds.size.width / 2
        var playbuttonHeight = UIScreen.mainScreen().bounds.size.height / 2
        if orientation == UIDeviceOrientation.LandscapeLeft || orientation == UIDeviceOrientation.LandscapeRight
        {
            playbuttonWidth = UIScreen.mainScreen().bounds.size.width * 0.7
            playbuttonHeight = UIScreen.mainScreen().bounds.size.height * 0.33
        }
        
        playButton.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (playbuttonWidth / 2), UIScreen.mainScreen().bounds.size.height * 0.15,playbuttonWidth, playbuttonHeight)
        
        
        let height:CGFloat = 31.0
        let marginSlider: CGFloat = playButton.frame.minX

        
        //levelSlider.transform = CGAffineTransformScale(levelSlider.transform, 0.3, 0.3)
        
        playButtonExstraLabel.frame = CGRectMake(0, playButton.frame.height * 0.7   , playButton.frame.width, playButton.frame.height * 0.15)
        //playButtonExstraLabel.text = "in \(orientationText) mode"
        playButtonExstraLabel2.frame = CGRectMake(0, playButton.frame.height * 0.85   , playButton.frame.width, playButton.frame.height * 0.15)

        levelSlider.frame = CGRect(x:  marginSlider, y: playButton.frame.maxY  + margin, width: UIScreen.mainScreen().bounds.size.width - (marginSlider * 2) - (playButton.frame.width * 0.1), height: height)
        
        selectFilterTypeButton.frame = CGRectMake(levelSlider.frame.maxX, playButton.frame.maxY, UIScreen.mainScreen().bounds.size.width * 0.1, UIScreen.mainScreen().bounds.size.width * 0.1)
        
        closeTagCheckView()
        
    }
    
    func sliderUpperLevelText() -> String
    {
        return Int(levelSlider.upperValue) > 2 ? "ridiculous" : "\(Int(levelSlider.upperValue))"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rangeSliderValueChanged(slider: RangeSlider) {
        //println("Range slider value changed: (\(Int(slider.lowerValue)) \(Int(slider.upperValue)))")
        playButtonExstraLabel2.text = "level \(Int(slider.lowerValue)) - \(sliderUpperLevelText())"
    }
    
    func playAction()
    {
        self.performSegueWithIdentifier("segueFromMainMenuToPlay", sender: nil)
    }
    
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueFromMainMenuToPlay") {
            var svc = segue!.destinationViewController as! PlayViewController
            svc.levelLow = Int(levelSlider.lowerValue)
            svc.levelHigh = Int(levelSlider.upperValue)
            svc.tags = self.tags
        }
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
    
    //MARK: TagCheckViewProtocol
    var listClosed = true
    func closeTagCheckView()
    {
        if listClosed
        {
            return
        }
        
        if self.tags.count < 3
        {
            var numberPrompt = UIAlertController(title: "Pick 3",
                message: "Select at least 3 tags",
                preferredStyle: .Alert)
            
            var numberTextField: UITextField?
            
            numberPrompt.addAction(UIAlertAction(title: "Ok",
                style: .Default,
                handler: { (action) -> Void in
                    
            }))
            
            
            self.presentViewController(numberPrompt,
                animated: true,
                completion: nil)
        }
        else
        {
            
            let rightLocation = tagsScrollView.center
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.tagsScrollView.transform = CGAffineTransformScale(self.tagsScrollView.transform, 0.1, 0.1)
                
                self.tagsScrollView.center = self.selectFilterTypeButton.center
                }, completion: { (value: Bool) in
                    self.tagsScrollView.transform = CGAffineTransformScale(self.tagsScrollView.transform, 0.1, 0.1)
                    self.tagsScrollView.alpha = 0
                    self.tagsScrollView.center = rightLocation
                    self.listClosed = true
                    self.tagsScrollViewEnableBackground.removeFromSuperview()
            })
        }
    }
    
    func reloadMarks(tags:[String])
    {
        self.tags = tags
    }
    
    func setupCheckboxView()
    {
        let bannerViewHeight = bannerView != nil ? bannerView!.frame.height : 0
        tagsScrollViewEnableBackground = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - bannerViewHeight))
        tagsScrollViewEnableBackground.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        tagsScrollViewEnableBackground.alpha = 0
        var scrollViewWidth = UIScreen.mainScreen().bounds.size.width * 0.6
        let orientation = UIDevice.currentDevice().orientation
        if orientation == UIDeviceOrientation.LandscapeLeft || orientation == UIDeviceOrientation.LandscapeRight
        {
            scrollViewWidth = UIScreen.mainScreen().bounds.size.width / 2
        }
        tagsScrollView = TagCheckScrollView(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (scrollViewWidth / 2) , UIScreen.mainScreen().bounds.size.height / 4, scrollViewWidth, UIScreen.mainScreen().bounds.size.height / 2))
        
        tagsScrollView.delegate = self
        tagsScrollView.alpha = 0
        tagsScrollViewEnableBackground.addSubview(tagsScrollView!)
        view.addSubview(tagsScrollViewEnableBackground)
    }
    
    func openFilterList()
    {
        
        
        let rightLocation = tagsScrollView.center
        tagsScrollView.transform = CGAffineTransformScale(tagsScrollView.transform, 0.1, 0.1)
        self.tagsScrollView.alpha = 1
        tagsScrollView.center = selectFilterTypeButton.center
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.tagsScrollViewEnableBackground.alpha = 1
            self.tagsScrollView.transform = CGAffineTransformIdentity
            
            self.tagsScrollView.center = rightLocation
            }, completion: { (value: Bool) in
                self.tagsScrollView.transform = CGAffineTransformIdentity
                self.tagsScrollView.alpha = 1
                self.tagsScrollView.center = rightLocation
                self.listClosed = false
        })
        
    }
    
}

