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
import StoreKit

class MainMenuViewController: UIViewController, CheckViewProtocol , ADBannerViewDelegate, HolderViewDelegate, SKProductsRequestDelegate{

    var backgroundView:UIView!
    
    //payment
    var product: SKProduct?
    var productID = "TimelineFeudAddFree1234"
    
    //buttons
    var challengeUsersButton:MenuButton!
    var practiceButton:MenuButton!
    var resultsButton:MenuButton!
    
    var newChallengeButton:ChallengeButton!
    var pendingChallengesButton:ChallengeButton!
    var orgNewChallengeButtonCenter:CGPoint!
    var orgPendingChallengesButtonCenter:CGPoint!
    
    var adFreeButton:UIButton!
    var selectFilterTypeButton:UIButton!

    var practicePlayButtonExstraLabel:UILabel!
    var challengePlayButtonExstraLabel:UILabel!
    var practicePlayButton:UIButton!
    var challengePlayButton:UIButton!

    
    var loadingDataView:UIView!
    var loadingDataLabel:UILabel!
    var datactrl:DataHandler!
    var tagsScrollViewEnableBackground:UIView!
    var tagsScrollView:CheckScrollView!
    
    let queue = NSOperationQueue()
    
    var globalGameStats:GameStats!
    var updateGlobalGameStats:Bool = false
    var newGameStatsValues:(Int,Int,Int)!
    let levelSlider = RangeSlider(frame: CGRectZero)
    var gametype:GameType!
    
    var tags:[String] = []
    var holderView = HolderView(frame: CGRectZero)
    
    var backButton:UIButton!
    
    var bannerView:ADBannerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch")
        
        datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl

        
        let marginButtons:CGFloat = 10
        let buttonWidth = UIScreen.mainScreen().bounds.size.width * 0.5
        var buttonHeight = UIScreen.mainScreen().bounds.size.height * 0.2 //UIScreen.mainScreen().bounds.size.height * 0.34

        
        challengeUsersButton = MenuButton(frame:CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (buttonWidth / 2), UIScreen.mainScreen().bounds.size.height * 0.15, buttonWidth, buttonHeight), title:"Challenge")
        challengeUsersButton.addTarget(self, action: "challengeAction", forControlEvents: UIControlEvents.TouchUpInside)
        let challengeBadge = NSUserDefaults.standardUserDefaults().integerForKey("challengesBadge")
        challengeUsersButton.setbadge(challengeBadge)
        challengeUsersButton.alpha = 0

        
        practiceButton = MenuButton(frame:CGRectMake(challengeUsersButton.frame.minX, challengeUsersButton.frame.maxY + marginButtons, buttonWidth, buttonHeight),title:"Practice")
        practiceButton.addTarget(self, action: "practiceAction", forControlEvents: UIControlEvents.TouchUpInside)
        practiceButton.alpha = 0
        
        resultsButton = MenuButton(frame:CGRectMake(challengeUsersButton.frame.minX, practiceButton.frame.maxY + marginButtons, buttonWidth, buttonHeight),title:"Results")
        resultsButton.addTarget(self, action: "resultAction", forControlEvents: UIControlEvents.TouchUpInside)
        let resultsBadge = NSUserDefaults.standardUserDefaults().integerForKey("resultsBadge")
        resultsButton.setbadge(resultsBadge)
        resultsButton.alpha = 0
        
        adFreeButton = UIButton(frame:CGRectMake(resultsButton.frame.maxX + marginButtons, resultsButton.frame.minY, buttonWidth / 3, buttonHeight))
        adFreeButton.addTarget(self, action: "buyProductAction", forControlEvents: UIControlEvents.TouchUpInside)
        adFreeButton.backgroundColor = UIColor.grayColor()
        adFreeButton.userInteractionEnabled = false
        adFreeButton.layer.cornerRadius = 5
        adFreeButton.layer.masksToBounds = true
        adFreeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        adFreeButton.titleLabel?.numberOfLines = 2
        adFreeButton.titleLabel?.textAlignment = NSTextAlignment.Center
        adFreeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        adFreeButton.alpha = 0
        let adFree = NSUserDefaults.standardUserDefaults().boolForKey("adFree")
        if !adFree
        {
            adFreeButton.backgroundColor = UIColor.blueColor()
            adFreeButton.userInteractionEnabled = true
            adFreeButton.setTitle("Remove\n ads☂ ", forState: UIControlState.Normal)
            self.canDisplayBannerAds = true
            //bannerView = ADBannerView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height))
            bannerView = ADBannerView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height))
            self.view.addSubview(bannerView!)
            self.bannerView?.delegate = self
            self.bannerView?.hidden = false
        }
        
        
        buttonHeight = UIScreen.mainScreen().bounds.size.height * 0.3
        

        //challenge type buttons
        newChallengeButton = ChallengeButton(frame:CGRectMake(self.challengeUsersButton.frame.minX, UIScreen.mainScreen().bounds.size.height * 0.15, buttonWidth, buttonHeight),title: "Make new")
        newChallengeButton.addTarget(self, action: "newChallengeAction", forControlEvents: UIControlEvents.TouchUpInside)
        newChallengeButton.alpha = 0
        
        pendingChallengesButton = ChallengeButton(frame:CGRectMake(self.resultsButton.frame.minX, self.newChallengeButton.frame.maxY + (marginButtons * 2) , buttonWidth, buttonHeight),title: "Take pending")
        pendingChallengesButton.addTarget(self, action: "pendingChallengesAction", forControlEvents: UIControlEvents.TouchUpInside)
        pendingChallengesButton.setbadge(challengeBadge)
        pendingChallengesButton.alpha = 0
        
        orgNewChallengeButtonCenter = newChallengeButton.center
        orgPendingChallengesButtonCenter = pendingChallengesButton.center
        
        practicePlayButton = UIButton(frame:CGRectZero)
        practicePlayButton.setTitle("Practice", forState: UIControlState.Normal)
        practicePlayButton.addTarget(self, action: "playPracticeAction", forControlEvents: UIControlEvents.TouchUpInside)
        practicePlayButton.backgroundColor = UIColor.blueColor()
        practicePlayButton.layer.cornerRadius = 5
        practicePlayButton.layer.masksToBounds = true
        
        challengePlayButton = UIButton(frame:CGRectZero)
        challengePlayButton.setTitle("New challenge\n\(GlobalConstants.numOfQuestionsForRound) questions", forState: UIControlState.Normal)
        challengePlayButton.titleLabel!.numberOfLines = 2
        challengePlayButton.addTarget(self, action: "playNewChallengeAction", forControlEvents: UIControlEvents.TouchUpInside)
        challengePlayButton.backgroundColor = UIColor.blueColor()
        challengePlayButton.layer.cornerRadius = 5
        challengePlayButton.layer.masksToBounds = true
        
        challengePlayButtonExstraLabel = UILabel(frame:CGRectZero)
        challengePlayButtonExstraLabel.backgroundColor = challengePlayButton.backgroundColor?.colorWithAlphaComponent(0)
        challengePlayButtonExstraLabel.textColor = UIColor.whiteColor()
        challengePlayButtonExstraLabel.font = UIFont.systemFontOfSize(12)
        challengePlayButtonExstraLabel.textAlignment = NSTextAlignment.Center
        challengePlayButton.addSubview(challengePlayButtonExstraLabel)

        practicePlayButtonExstraLabel = UILabel(frame:CGRectZero)
        practicePlayButtonExstraLabel.backgroundColor = practicePlayButton.backgroundColor?.colorWithAlphaComponent(0)
        practicePlayButtonExstraLabel.textColor = UIColor.whiteColor()
        practicePlayButtonExstraLabel.font = UIFont.systemFontOfSize(12)
        practicePlayButtonExstraLabel.textAlignment = NSTextAlignment.Center
        practicePlayButton.addSubview(practicePlayButtonExstraLabel)


        levelSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        levelSlider.curvaceousness = 0.0
        levelSlider.maximumValue = Double(GlobalConstants.maxLevel) + 0.5
        levelSlider.minimumValue = Double(GlobalConstants.minLevel)
        levelSlider.typeValue = sliderType.bothLowerAndUpper

        
        selectFilterTypeButton = UIButton(frame: CGRectZero)
        selectFilterTypeButton.setTitle("📋", forState: UIControlState.Normal)
        selectFilterTypeButton.addTarget(self, action: "openFilterList", forControlEvents: UIControlEvents.TouchUpInside)
        selectFilterTypeButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        
        
        challengePlayButton.alpha = 0
        practicePlayButton.alpha = 0
        levelSlider.alpha = 0
        selectFilterTypeButton.alpha = 0
        
        self.view.addSubview(challengeUsersButton)
        self.view.addSubview(practiceButton)
        self.view.addSubview(resultsButton)
        self.view.addSubview(adFreeButton)
        
        self.view.addSubview(newChallengeButton)
        self.view.addSubview(pendingChallengesButton)
        
        self.view.addSubview(challengePlayButton)
        self.view.addSubview(practicePlayButton)
        self.view.addSubview(levelSlider)
        self.view.addSubview(selectFilterTypeButton)
        
        globalGameStats = GameStats(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width * 0.4, UIScreen.mainScreen().bounds.size.height * 0.08),okScore: Int(datactrl.okScoreValue as! NSNumber),goodScore: Int(datactrl.goodScoreValue as! NSNumber),loveScore: Int(datactrl.loveScoreValue as! NSNumber))
        self.view.addSubview(globalGameStats)
        
        setupCheckboxView()
        setupFirstLevelMenu()
        setupDynamicPlayButton()

        if firstLaunch
        {
            if Int(datactrl.dataPopulatedValue as! NSNumber) <= 0
            {
                loadingDataLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
                loadingDataLabel.text = "Loading data.."
                loadingDataLabel.textAlignment = NSTextAlignment.Center
                loadingDataView = UIView(frame: CGRectMake(50, 50, 200, 50))
                loadingDataView.backgroundColor = UIColor.redColor()
                loadingDataView.addSubview(loadingDataLabel)
                self.view.addSubview(loadingDataView)
                
                let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity");
                pulseAnimation.duration = 0.3
                pulseAnimation.toValue = NSNumber(float: 0.3)
                pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                pulseAnimation.autoreverses = true
                pulseAnimation.repeatCount = 100
                pulseAnimation.delegate = self
                loadingDataView.layer.addAnimation(pulseAnimation, forKey: "asd")
            }
        }
        else
        {
            self.challengeUsersButton.alpha = 1
            self.practiceButton.alpha = 1
            self.resultsButton.alpha = 1
            self.adFreeButton.alpha = 1
            requestProductData()
            //setupAfterPopulateData()
        }
        
        updateBadges()
        
        let backButtonMargin:CGFloat = 10
        backButton = UIButton(frame: CGRectZero)
        backButton.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width - GlobalConstants.smallButtonSide - backButtonMargin, backButtonMargin, GlobalConstants.smallButtonSide, GlobalConstants.smallButtonSide)
        backButton.backgroundColor = UIColor.whiteColor()
        backButton.layer.borderColor = UIColor.grayColor().CGColor
        backButton.layer.borderWidth = 1
        backButton.layer.cornerRadius = 5
        backButton.layer.masksToBounds = true
        backButton.setTitle("🔙", forState: UIControlState.Normal)
        backButton.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.alpha = 0
        view.addSubview(backButton)

        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch")
        if firstLaunch
        {
            holderView = HolderView(frame: view.bounds)
            holderView.delegate = self
            view.addSubview(holderView)
            holderView.startAnimation()
            
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "firstlaunch")
        }
        
        if updateGlobalGameStats
        {
            
            globalGameStats.addOkPoints(newGameStatsValues.0, completionOKPoints: { () in
                
                self.globalGameStats.addLovePoints(self.newGameStatsValues.2, completionLovePoints: { () in
                    self.updateGlobalGameStats = false
                    self.datactrl.updateGameData(self.newGameStatsValues.0,deltaGoodPoints: self.newGameStatsValues.1,deltaLovePoints: self.newGameStatsValues.2)
                    self.datactrl.saveGameData()
                })
                
            })
        }
        
        bannerView?.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
        bannerView!.center = CGPoint(x: bannerView!.center.x, y: self.view.bounds.size.height - bannerView!.frame.size.height / 2)
        
    }

    /*
    override func viewWillAppear(animated: Bool) {
        bannerView?.translatesAutoresizingMaskIntoConstraints = false
        
        bannerView?.frame = CGRectZero
        bannerView!.center = CGPoint(x: bannerView!.center.x, y: self.view.bounds.size.height - bannerView!.frame.size.height / 2)
    }
*/
    
    
    override func viewDidLayoutSubviews() {
        
        loadingDataView?.frame =  CGRectMake(50, 50, 200, 50)
        bannerView!.center = CGPoint(x: bannerView!.center.x, y: self.view.bounds.size.height - bannerView!.frame.size.height / 2)
        
        
        
        //setupFirstLevelMenu()
        
        //setupChallengeTypeButtons()
        
        //setupDynamicPlayButton()
    }
    
    func enterForground()
    {
        updateBadges()
    }
    
    func updateBadges()
    {

        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.recieveNumberOfResultsNotDownloaded()
        }
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.recieveNumberOfPendingChallenges()
        }
    }
    
    func requestProductData()
    {
        let adFree = NSUserDefaults.standardUserDefaults().boolForKey("adFree")
        if adFree
        {
            return
        }
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers:  NSSet(objects: self.productID) as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
                if url != nil
                {
                    UIApplication.sharedApplication().openURL(url!)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        var products = response.products
        
        if (products.count != 0) {
            product = products[0]
            //buyButton.enabled = true
            //productTitle.text = product!.localizedTitle
            //productDescription.text = product!.localizedDescription
            
            adFreeButton.backgroundColor = UIColor.blueColor()
            adFreeButton.userInteractionEnabled = true
            
        } else {
            //productTitle.text = "Product not found"
        }
        
        let invalidProducts = response.invalidProductIdentifiers
        
        for product in invalidProducts
        {
            print("Product not found: \(product)")
        }
    }
    
    func buyProductAction() {
        
        let numberPrompt = UIAlertController(title: "Remove ads",
            message: "",
            preferredStyle: .Alert)
        
        
        numberPrompt.addAction(UIAlertAction(title: "Buy",
            style: .Default,
            handler: { (action) -> Void in
                self.addProductPayment()
        }))
        numberPrompt.addAction(UIAlertAction(title: "Restore purchase",
            style: .Default,
            handler: { (action) -> Void in
                
                self.addProductPayment()
                
        }))
        
        self.presentViewController(numberPrompt,
            animated: true,
            completion: nil)
    }
    
    func addProductPayment()
    {
        let payment = SKPayment(product: product!)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        
        for transaction in transactions as! [SKPaymentTransaction] {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.Purchased:
                self.removeAds()
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            case SKPaymentTransactionState.Restored:
                self.removeAds()
                SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
            case SKPaymentTransactionState.Failed:
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func removeAds() {
        
        datactrl.adFreeValue = 1
        datactrl.saveGameData()
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "adFree")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.bannerView?.hidden = true
        self.bannerView?.frame.offsetInPlace(dx: 0, dy: self.bannerView!.frame.height)
        
        adFreeButton.backgroundColor = UIColor.grayColor()
        adFreeButton.userInteractionEnabled = false
        adFreeButton.setTitle(" ", forState: UIControlState.Normal)
    }
    
    func loadScreenFinished() {
        self.view.backgroundColor = UIColor.whiteColor()
        //holderView.removeFromSuperview()
        holderView.alpha = 0
        challengeUsersButton.transform = CGAffineTransformScale(challengeUsersButton.transform, 0.1, 0.1)
        practiceButton.transform = CGAffineTransformScale(practiceButton.transform, 0.1, 0.1)
        resultsButton.transform = CGAffineTransformScale(resultsButton.transform, 0.1, 0.1)
        adFreeButton.transform = CGAffineTransformScale(adFreeButton.transform, 0.1, 0.1)
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.challengeUsersButton.alpha = 1
            self.practiceButton.alpha = 1
            self.resultsButton.alpha = 1
            self.adFreeButton.alpha = 1
            self.challengeUsersButton.transform = CGAffineTransformIdentity
            self.practiceButton.transform = CGAffineTransformIdentity
            self.resultsButton.transform = CGAffineTransformIdentity
            self.adFreeButton.transform = CGAffineTransformIdentity
            }, completion: { (value: Bool) in
                self.bannerView!.center = CGPoint(x: self.bannerView!.center.x, y: self.view.bounds.size.height - self.bannerView!.frame.size.height / 2)
        })
        
        requestProductData()
        populateDataIfNeeded()
        
        /*
        datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl
        datactrl.addRecordToGameResults("2,22,Elizabethhhh,1,1000,1-3 from Elizabethhhh,,4321")
        
        datactrl.saveGameData()
        datactrl.loadGameData()
        */
    }
    
    func populateDataIfNeeded()
    {
        if Int(datactrl.dataPopulatedValue as! NSNumber) <= 0
        {
            
            datactrl.populateData({ () in
                
                self.loadingDataView.alpha = 0
                self.loadingDataView.layer.removeAllAnimations()
            })
            
            loadingDataView?.frame =  CGRectMake(50, 50, 200, 50)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    func setupFirstLevelMenu()
    {
        challengeUsersButton.orgCenter = challengeUsersButton.center
        practiceButton.orgCenter = practiceButton.center
        resultsButton.orgCenter = resultsButton.center
    }
    
    func setupDynamicPlayButton()
    {
        let margin: CGFloat = 20.0
        let sliderAndFilterbuttonHeight:CGFloat = 31.0

        let playbuttonWidth = self.practiceButton.frame.maxX - self.challengeUsersButton.frame.minX
        let playbuttonHeight = self.resultsButton.frame.maxY - self.challengeUsersButton.frame.minY - sliderAndFilterbuttonHeight - margin

        
        practicePlayButton.frame = CGRectMake(self.challengeUsersButton.frame.minX, self.challengeUsersButton.frame.minY,playbuttonWidth, playbuttonHeight)
        challengePlayButton.frame = practicePlayButton.frame
        let marginSlider: CGFloat = practicePlayButton.frame.minX

        
        practicePlayButtonExstraLabel.frame = CGRectMake(0, practicePlayButton.frame.height * 0.7   , practicePlayButton.frame.width, practicePlayButton.frame.height * 0.15)
        practicePlayButtonExstraLabel.text = "Level \(Int(levelSlider.lowerValue)) - \(sliderUpperLevelText())"
        
        challengePlayButtonExstraLabel.frame = CGRectMake(0, challengePlayButton.frame.height * 0.7   , practicePlayButton.frame.width, challengePlayButton.frame.height * 0.15)
        challengePlayButtonExstraLabel.text = "Level \(Int(levelSlider.lowerValue)) - \(sliderUpperLevelText())"
        
        levelSlider.frame = CGRect(x:  marginSlider, y: practicePlayButton.frame.maxY  + margin, width: UIScreen.mainScreen().bounds.size.width - (marginSlider * 2) - (practicePlayButton.frame.width * 0.2), height: sliderAndFilterbuttonHeight)
        
        selectFilterTypeButton.frame = CGRectMake(levelSlider.frame.maxX, practicePlayButton.frame.maxY + margin, UIScreen.mainScreen().bounds.size.width * 0.2, levelSlider.frame.height)

        levelSlider.alpha = 0
        selectFilterTypeButton.alpha = 0
        

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
        if Int(slider.lowerValue) == Int(slider.upperValue)
        {
            let text = "Level \(sliderUpperLevelText())"
            practicePlayButtonExstraLabel.text = text
            challengePlayButtonExstraLabel.text = text
        }
        else
        {
            let text = "Level \(Int(slider.lowerValue)) - \(sliderUpperLevelText())"
            practicePlayButtonExstraLabel.text = text
            challengePlayButtonExstraLabel.text = text
        }
    }

    
    func backAction()
    {
        backButton.alpha = 0
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.challengeUsersButton.center = self.challengeUsersButton.orgCenter
            self.challengeUsersButton.alpha = 1
            self.challengeUsersButton.transform = CGAffineTransformIdentity
            self.practiceButton.center = self.practiceButton.orgCenter
            self.practiceButton.alpha = 1
            self.practiceButton.transform = CGAffineTransformIdentity
            self.resultsButton.center = self.resultsButton.orgCenter
            self.resultsButton.alpha = 1
            self.resultsButton.transform = CGAffineTransformIdentity
            
            self.practicePlayButton.alpha = 0
            self.levelSlider.alpha = 0
            self.selectFilterTypeButton.alpha = 0
            self.newChallengeButton.alpha = 0
            self.pendingChallengesButton.alpha = 0
            self.newChallengeButton.center = self.orgNewChallengeButtonCenter
            self.pendingChallengesButton.center = self.orgPendingChallengesButtonCenter
            
            self.challengePlayButton.alpha = 0
            }, completion: { (value: Bool) in
                
                
        })
    }
    
    func newChallengeAction()
    {
        self.challengePlayButton.alpha = 0
        self.challengePlayButton.transform = CGAffineTransformScale(self.challengePlayButton.transform, 0.1, 0.1)
        self.levelSlider.alpha = 0
        self.levelSlider.transform = CGAffineTransformScale(self.levelSlider.transform, 0.1, 0.1)
        
        let centerScreen = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.newChallengeButton.center = centerScreen
            self.newChallengeButton.transform = CGAffineTransformScale(self.challengeUsersButton.transform, 0.1, 0.1)
            self.pendingChallengesButton.center = centerScreen
            self.pendingChallengesButton.transform = CGAffineTransformScale(self.practiceButton.transform, 0.1, 0.1)
            self.backButton.alpha = 1
            }, completion: { (value: Bool) in
                
                self.newChallengeButton.alpha = 0
                self.pendingChallengesButton.alpha = 0
                
                self.challengePlayButton.alpha = 1
                self.levelSlider.alpha = 1

                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.challengePlayButton.transform = CGAffineTransformIdentity
                    self.levelSlider.transform = CGAffineTransformIdentity
 
                    }, completion: { (value: Bool) in
                        
                })
        })
    }
    
    
    
    func practiceAction()
    {
        self.practicePlayButton.alpha = 0
        self.practicePlayButton.transform = CGAffineTransformScale(self.practicePlayButton.transform, 0.1, 0.1)
        self.levelSlider.alpha = 0
        self.levelSlider.transform = CGAffineTransformScale(self.levelSlider.transform, 0.1, 0.1)
        self.selectFilterTypeButton.alpha = 0
        self.selectFilterTypeButton.transform = CGAffineTransformScale(self.selectFilterTypeButton.transform, 0.1, 0.1)

        
        let centerScreen = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.challengeUsersButton.center = centerScreen
            self.challengeUsersButton.transform = CGAffineTransformScale(self.challengeUsersButton.transform, 0.1, 0.1)
            self.practiceButton.center = centerScreen
            self.practiceButton.transform = CGAffineTransformScale(self.practiceButton.transform, 0.1, 0.1)
            self.resultsButton.center = centerScreen
            self.resultsButton.transform = CGAffineTransformScale(self.resultsButton.transform, 0.1, 0.1)
            self.adFreeButton?.center = centerScreen
            self.adFreeButton?.transform = CGAffineTransformScale(self.adFreeButton!.transform, 0.1, 0.1)
            
            self.backButton.alpha = 1
            
            }, completion: { (value: Bool) in
                
                self.challengeUsersButton.alpha = 0
                self.practiceButton.alpha = 0
                self.resultsButton.alpha = 0
                self.adFreeButton?.alpha = 0
                
                self.practicePlayButton.alpha = 1
                self.levelSlider.alpha = 1
                self.selectFilterTypeButton.alpha = 1
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.practicePlayButton.transform = CGAffineTransformIdentity
                    self.levelSlider.transform = CGAffineTransformIdentity
                    self.selectFilterTypeButton.transform = CGAffineTransformIdentity
                    }, completion: { (value: Bool) in
                })
        })
    }

    
    
    func playPracticeAction()
    {
        datactrl.fetchData(tags,fromLevel:Int(levelSlider.lowerValue),toLevel: Int(levelSlider.upperValue))
        
        gametype = GameType.training
        self.performSegueWithIdentifier("segueFromMainMenuToPlay", sender: nil)
    }
    
    func playNewChallengeAction()
    {
        datactrl.fetchData(tags,fromLevel:Int(levelSlider.lowerValue),toLevel: Int(levelSlider.upperValue))
        
        gametype = GameType.makingChallenge
        self.performSegueWithIdentifier("segueFromMainMenuToChallenge", sender: nil)
    }
    
    func pendingChallengesAction()
    {
        gametype = GameType.takingChallenge
        self.performSegueWithIdentifier("segueFromMainMenuToChallenge", sender: nil)
    }
    
    func setupChallengeTypeButtons()
    {
        newChallengeButton.alpha = 0
        pendingChallengesButton.alpha = 0

        
        let buttonWidth = practiceButton.frame.maxX - challengeUsersButton.frame.minX
        let buttonHeight = practiceButton.frame.height
        
        newChallengeButton.frame = CGRectMake(self.challengeUsersButton.frame.minX, UIScreen.mainScreen().bounds.size.height * 0.15, buttonWidth, buttonHeight)
        pendingChallengesButton.frame = CGRectMake(self.resultsButton.frame.minX, self.resultsButton.frame.minY , buttonWidth, buttonHeight)

    }
    
    func resultAction()
    {
        self.performSegueWithIdentifier("segueFromResultsToMainMenu", sender: nil)
    }
    
    func challengeAction()
    {

        self.newChallengeButton.transform = CGAffineTransformScale(self.newChallengeButton.transform, 0.1, 0.1)
        self.pendingChallengesButton.transform = CGAffineTransformScale(self.pendingChallengesButton.transform, 0.1, 0.1)
        let centerScreen = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            
            self.challengeUsersButton.center = centerScreen
            self.challengeUsersButton.transform = CGAffineTransformScale(self.challengeUsersButton.transform, 0.1, 0.1)
            self.practiceButton.center = centerScreen
            self.practiceButton.transform = CGAffineTransformScale(self.practiceButton.transform, 0.1, 0.1)
            self.resultsButton.center = centerScreen
            self.resultsButton.transform = CGAffineTransformScale(self.resultsButton.transform, 0.1, 0.1)
            self.adFreeButton.center = centerScreen
            self.adFreeButton.transform = CGAffineTransformScale(self.adFreeButton.transform, 0.1, 0.1)
            self.backButton.alpha = 1
            
            }, completion: { (value: Bool) in
                
                self.challengeUsersButton.alpha = 0
                self.practiceButton.alpha = 0
                self.resultsButton.alpha = 0
                self.adFreeButton.alpha = 0
                
                self.newChallengeButton.alpha = 1
                self.pendingChallengesButton.alpha = 1
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    self.newChallengeButton.transform = CGAffineTransformIdentity
                    self.pendingChallengesButton.transform = CGAffineTransformIdentity
                    }, completion: { (value: Bool) in
                })
        })
    }

    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueFromMainMenuToPlay") {
            let svc = segue!.destinationViewController as! PlayViewController
            svc.gametype = gametype
        }
        
        if (segue.identifier == "segueFromMainMenuToChallenge") {
            let svc = segue!.destinationViewController as! ChallengeViewController
            svc.passingLevelLow = Int(levelSlider.lowerValue)
            svc.passingLevelHigh = Int(levelSlider.upperValue)
            svc.passingTags = self.tags
            svc.gametype = self.gametype
        }
    }
    
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        let adFree = NSUserDefaults.standardUserDefaults().boolForKey("adFree")
        self.bannerView?.hidden = adFree
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return willLeave
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        let adFree = NSUserDefaults.standardUserDefaults().boolForKey("adFree")
        self.bannerView?.hidden = adFree
    }
    
    //MARK: TagCheckViewProtocol
    var listClosed = true
    func closeCheckView(sender:CheckScrollView)
    {
        if listClosed
        {
            return
        }
        
        if self.tags.count < 3
        {
            let numberPrompt = UIAlertController(title: "Pick 3",
                message: "Select at least 3 tags",
                preferredStyle: .Alert)

            
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
            
            let rightLocation = sender.center
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                sender.transform = CGAffineTransformScale(sender.transform, 0.1, 0.1)
                
                sender.center = self.selectFilterTypeButton.center
                }, completion: { (value: Bool) in
                    sender.transform = CGAffineTransformScale(sender.transform, 0.1, 0.1)
                    sender.alpha = 0
                    sender.center = rightLocation
                    self.listClosed = true
                    self.tagsScrollViewEnableBackground.alpha = 0
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
        let values:[String:String] = ["#war":"#war","#headOfState":"#headOfState","#science":"#science","#discovery":"#discovery","#invention":"#invention","#sport":"#sport","#miscellaneous":"#miscellaneous"]
        tagsScrollView = CheckScrollView(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (scrollViewWidth / 2) , UIScreen.mainScreen().bounds.size.height / 4, scrollViewWidth, UIScreen.mainScreen().bounds.size.height / 2), initialValues: values,itemsName: "tag",itemsChecked:true)

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
    
    func recieveNumberOfResultsNotDownloaded()
    {
        let currentbadge = NSUserDefaults.standardUserDefaults().integerForKey("resultsBadge")
        if currentbadge == 0
        {
            if let token = NSUserDefaults.standardUserDefaults().stringForKey("deviceToken")
            {
                if token == ""
                {
                    return
                }
                let client = (UIApplication.sharedApplication().delegate as! AppDelegate).client
                let jsonDictionaryHandle = ["token":token]
                client!.invokeAPI("idleresults", data: nil, HTTPMethod: "GET", parameters: jsonDictionaryHandle as [NSObject : AnyObject], headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
                    
                    
                    if error != nil
                    {
                        print("\(error)")
                        let reportError = (UIApplication.sharedApplication().delegate as! AppDelegate).reportErrorHandler
                        reportError?.reportError("\(error)")

                    }
                    if result != nil
                    {
                        var resultsBadge = NSString(data: result, encoding:NSUTF8StringEncoding) as! String
                        resultsBadge = String(resultsBadge.characters.dropLast().dropFirst())
                        print(resultsBadge)
                        let resultsBadgeInt = Int(resultsBadge)

                        dispatch_async(dispatch_get_main_queue()) {
                            self.resultsButton.setbadge(resultsBadgeInt!)
                        }
                        
                    }
                    if response != nil
                    {
                        print("\(response)")
                    }
                    
                    
                })
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue()) {
                self.resultsButton.setbadge(currentbadge)
            }
        }
    }
    
    func recieveNumberOfPendingChallenges()
    {
        
        let currentbadge = NSUserDefaults.standardUserDefaults().integerForKey("challengesBadge")
        if currentbadge == 0
        {
            if let token = NSUserDefaults.standardUserDefaults().stringForKey("deviceToken")
            {
                if token == ""
                {
                    return
                }
                
                let client = (UIApplication.sharedApplication().delegate as! AppDelegate).client
                let jsonDictionaryHandle = ["token":token]
                client!.invokeAPI("pendingchallenges", data: nil, HTTPMethod: "GET", parameters: jsonDictionaryHandle as [NSObject : AnyObject], headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
                    
                    
                    if error != nil
                    {
                        print("\(error)")
                        
                        let reportError = (UIApplication.sharedApplication().delegate as! AppDelegate).reportErrorHandler
                        reportError?.reportError("\(error)")

                    }
                    if result != nil
                    {
                        
                        /*
                        var resultsBadgeInt: NSInteger = 0
                        result.getBytes(&resultsBadgeInt, length: sizeof(NSInteger))
                        NSUserDefaults.standardUserDefaults().setInteger(resultsBadgeInt, forKey: "challengesBadge")
                        */
                        var resultsBadge = NSString(data: result, encoding:NSUTF8StringEncoding) as! String
                        resultsBadge = String(resultsBadge.characters.dropLast().dropFirst())
                        
                        let resultsBadgeInt = Int(resultsBadge)
                        print(resultsBadgeInt)
                        dispatch_async(dispatch_get_main_queue()) {
                            self.challengeUsersButton.setbadge(resultsBadgeInt!)
                            self.pendingChallengesButton.setbadge(resultsBadgeInt!)
                        }
                    }
                    if response != nil
                    {
                        print("\(response)")
                    }
                    
                    
                })
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue()) {
                self.challengeUsersButton.setbadge(currentbadge)
                self.pendingChallengesButton.setbadge(currentbadge)
            }
        }
        
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.LandscapeLeft, UIInterfaceOrientationMask.LandscapeRight]
    }

}

