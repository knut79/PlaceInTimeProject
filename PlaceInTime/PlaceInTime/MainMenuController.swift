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
    var challengeUsersButton:UIButton!
    var resultsButton:UIButton!
    var adFreeButton:UIButton!
    var dynamicPlayButton:UIButton!
    var newChallengeButton:UIButton!
    var pendingChallengesButton:UIButton!
    var practiceButton:UIButton!
    var selectFilterTypeButton:UIButton!
    
    
    var playButtonExstraLabel:UILabel!
    //var playButtonExstraLabel2:UILabel!
    
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
    var gametype:gameType!
    
    var tags:[String] = []
    var holderView = HolderView(frame: CGRectZero)
    
    let logo1 = UILabel()
    let logo2 = UILabel()
    let logo3 = UILabel()
    
    var bannerView:ADBannerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestProductData()
        
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch")
        if firstLaunch
        {
            self.view.backgroundColor = UIColor.blueColor()
        }
        
        datactrl = DataHandler()

        challengeUsersButton = UIButton(frame:CGRectZero)
        challengeUsersButton.addTarget(self, action: "challengeAction", forControlEvents: UIControlEvents.TouchUpInside)
        challengeUsersButton.backgroundColor = UIColor.blueColor()
        challengeUsersButton.layer.cornerRadius = 5
        challengeUsersButton.layer.masksToBounds = true
        challengeUsersButton.setTitle("Challenge", forState: UIControlState.Normal)
        
        practiceButton = UIButton(frame:CGRectZero)
        practiceButton.addTarget(self, action: "practiceAction", forControlEvents: UIControlEvents.TouchUpInside)
        practiceButton.backgroundColor = UIColor.blueColor()
        practiceButton.layer.cornerRadius = 5
        practiceButton.layer.masksToBounds = true
        practiceButton.setTitle("Practice", forState: UIControlState.Normal)
        
        resultsButton = UIButton(frame:CGRectZero)
        resultsButton.addTarget(self, action: "resultAction", forControlEvents: UIControlEvents.TouchUpInside)
        resultsButton.backgroundColor = UIColor.blueColor()
        resultsButton.layer.cornerRadius = 5
        resultsButton.layer.masksToBounds = true
        resultsButton.setTitle("Results", forState: UIControlState.Normal)
        
        adFreeButton = UIButton(frame:CGRectZero)
        adFreeButton.addTarget(self, action: "buyProductAction", forControlEvents: UIControlEvents.TouchUpInside)
        adFreeButton.backgroundColor = UIColor.grayColor()
        adFreeButton.userInteractionEnabled = false
        adFreeButton.layer.cornerRadius = 5
        adFreeButton.layer.masksToBounds = true
        adFreeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        adFreeButton.setTitle("Remove ads", forState: UIControlState.Normal)
        
        //challenge type buttons
        newChallengeButton = UIButton(frame:CGRectZero)
        newChallengeButton.addTarget(self, action: "newChallengeAction", forControlEvents: UIControlEvents.TouchUpInside)
        newChallengeButton.backgroundColor = UIColor.blueColor()
        newChallengeButton.layer.cornerRadius = 5
        newChallengeButton.layer.masksToBounds = true
        newChallengeButton.setTitle("New", forState: UIControlState.Normal)
        
        pendingChallengesButton = UIButton(frame:CGRectZero)
        pendingChallengesButton.addTarget(self, action: "pendingChallengesAction", forControlEvents: UIControlEvents.TouchUpInside)
        pendingChallengesButton.backgroundColor = UIColor.blueColor()
        pendingChallengesButton.layer.cornerRadius = 5
        pendingChallengesButton.layer.masksToBounds = true
        pendingChallengesButton.setTitle("Pending", forState: UIControlState.Normal)
        
        // Do any additional setup after loading the view, typically from a nib.
        dynamicPlayButton = UIButton(frame:CGRectZero)
        dynamicPlayButton.backgroundColor = UIColor.blueColor()
        dynamicPlayButton.layer.cornerRadius = 5
        dynamicPlayButton.layer.masksToBounds = true
        dynamicPlayButton.setTitle("Play", forState: UIControlState.Normal)
        
        playButtonExstraLabel = UILabel(frame:CGRectZero)
        playButtonExstraLabel.backgroundColor = dynamicPlayButton.backgroundColor?.colorWithAlphaComponent(0)
        playButtonExstraLabel.textColor = UIColor.whiteColor()
        playButtonExstraLabel.font = UIFont.systemFontOfSize(12)
        playButtonExstraLabel.textAlignment = NSTextAlignment.Center
        dynamicPlayButton.addSubview(playButtonExstraLabel)


        levelSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        levelSlider.curvaceousness = 0.0
        levelSlider.maximumValue = Double(maxLevel) + 0.5
        levelSlider.minimumValue = Double(minLevel)
        levelSlider.typeValue = sliderType.bothLowerAndUpper

        
        selectFilterTypeButton = UIButton(frame: CGRectZero)
        selectFilterTypeButton.setTitle("📋", forState: UIControlState.Normal)
        selectFilterTypeButton.addTarget(self, action: "openFilterList", forControlEvents: UIControlEvents.TouchUpInside)
        selectFilterTypeButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        
        

        if firstLaunch
        {


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
        else
        {
            setupAfterPopulateData()
        }

    }
    
    func requestProductData()
    {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers:
                NSSet(objects: self.productID) as Set<NSObject>)
            request.delegate = self
            request.start()
        } else {
            var alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.Alert)
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
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        
        var products = response.products
        
        if (products.count != 0) {
            product = products[0] as? SKProduct
            //buyButton.enabled = true
            //productTitle.text = product!.localizedTitle
            //productDescription.text = product!.localizedDescription
            /*
            var noMarkedNumbersPrompt = UIAlertController(title: product!.localizedTitle,
                message: "\(product!.localizedDescription) \(product!.price as NSDecimalNumber)$",
                preferredStyle: .Alert)
            
            noMarkedNumbersPrompt.addAction(UIAlertAction(title: "Buy",
                style: .Default,
                handler: { (action) -> Void in
                    return
            }))
            noMarkedNumbersPrompt.addAction(UIAlertAction(title: "Cancel",
                style: .Default,
                handler: { (action) -> Void in
                    return
            }))
            
            self.presentViewController(noMarkedNumbersPrompt,
                animated: true,
                completion: nil)
            */
            
            adFreeButton.backgroundColor = UIColor.blueColor()
            adFreeButton.userInteractionEnabled = true
            
        } else {
            //productTitle.text = "Product not found"
        }
        
        products = response.invalidProductIdentifiers
        
        for product in products
        {
            println("Product not found: \(product)")
        }
    }
    
    func buyProductAction(sender: AnyObject) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        
        for transaction in transactions as! [SKPaymentTransaction] {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.Purchased:
                self.removeAdds()
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            case SKPaymentTransactionState.Restored:
                self.removeAdds()
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            case SKPaymentTransactionState.Failed:
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func removeAdds() {
        let appdelegate = UIApplication.sharedApplication().delegate
            as! AppDelegate
        
        datactrl.adFreeID = 1
        datactrl.saveGameData()
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "adFree")
        self.bannerView?.hidden = true
        
        adFreeButton.backgroundColor = UIColor.grayColor()
        adFreeButton.userInteractionEnabled = false
        adFreeButton.setTitle("Ad free version", forState: UIControlState.Normal)
    }
    
    func loadScreenFinished() {
        
        populateDataIfNeeded()
    }
    
    func populateDataIfNeeded()
    {
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
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        //DO at firstLoad
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch")
        if firstLaunch
        {
            let boxSize: CGFloat = 100.0
            holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
                y: view.bounds.height / 2 - boxSize / 2,
                width: boxSize,
                height: boxSize)
            holderView.parentFrame = view.frame
            holderView.delegate = self
            view.addSubview(holderView)
            holderView.startAnimation()
            
            logo1.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - 225, UIScreen.mainScreen().bounds.size.height * 0.75, 200, 50)
            logo1.textAlignment = NSTextAlignment.Right
            logo1.textColor = UIColor.whiteColor()
            logo1.font = UIFont.boldSystemFontOfSize(25)
            logo1.alpha = 0
            logo1.text = "Time"
            
            self.view.addSubview(logo1)
            
            logo2.frame = CGRectMake(logo1.frame.maxX, UIScreen.mainScreen().bounds.size.height * 0.75, 50, 50)
            logo2.textAlignment = NSTextAlignment.Left
            logo2.textColor = UIColor.whiteColor()
            logo2.font = UIFont.boldSystemFontOfSize(25)
            logo2.alpha = 0
            logo2.text = "line"
            
            self.view.addSubview(logo2)
            
            logo3.frame = CGRectMake(logo2.frame.maxX, UIScreen.mainScreen().bounds.size.height * 0.75, 200, 50)
            logo3.textAlignment = NSTextAlignment.Left
            logo3.textColor = UIColor.whiteColor()
            logo3.font = UIFont.boldSystemFontOfSize(25)
            logo3.alpha = 0
            logo3.text = " Feud"
            
            self.view.addSubview(logo3)
            
            let orgLogo1Center = logo1.center
            let orgLogo2Center = logo2.center
            let orgLogo3Center = logo3.center
            logo1.transform = CGAffineTransformScale(logo1.transform, 0.1, 0.1)
            logo2.transform = CGAffineTransformScale(logo2.transform, 0.1, 0.1)
            logo3.transform = CGAffineTransformScale(logo3.transform, 0.1, 0.1)
            logo1.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
            logo2.center = logo1.center
            logo3.center = logo1.center
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                self.logo1.transform = CGAffineTransformIdentity
                self.logo1.alpha = 1
                self.logo1.center = orgLogo1Center
                }, completion: { (value: Bool) in
                    UIView.animateWithDuration(0.35, animations: { () -> Void in
                        self.logo2.transform = CGAffineTransformIdentity
                        self.logo2.alpha = 1
                        self.logo2.center = orgLogo2Center
                        }, completion: { (value: Bool) in
                            UIView.animateWithDuration(0.35, animations: { () -> Void in
                                self.logo3.transform = CGAffineTransformIdentity
                                self.logo3.alpha = 1
                                self.logo3.center = orgLogo3Center
                                })
                            
                    })
                    
            })
            
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "firstlaunch")
        }
        //END DO

    }
    
    func setupAfterPopulateData()
    {
        self.canDisplayBannerAds = true
        bannerView = ADBannerView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 44, UIScreen.mainScreen().bounds.size.width, 44))
        //bannerView = ADBannerView(frame: CGRectZero)
        self.view.addSubview(bannerView!)
        self.bannerView?.delegate = self
        self.bannerView?.hidden = false
        
        levelSlider.alpha = 0
        selectFilterTypeButton.alpha = 0
        
        
        //self.view.addSubview(self.playButton)

        //challengeUsersButton.alpha = 0
        //practiceButton.alpha = 0
        self.view.addSubview(challengeUsersButton)
        self.view.addSubview(practiceButton)
        self.view.addSubview(resultsButton)
        self.view.addSubview(adFreeButton)
        
        self.view.addSubview(newChallengeButton)
        self.view.addSubview(pendingChallengesButton)
        
        self.view.addSubview(dynamicPlayButton)
        self.view.addSubview(levelSlider)
        self.view.addSubview(selectFilterTypeButton)
        
        globalGameStats = GameStats(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width * 0.4, UIScreen.mainScreen().bounds.size.height * 0.08),okScore: Int(datactrl.okScoreID as! NSNumber),goodScore: Int(datactrl.goodScoreID as! NSNumber),loveScore: Int(datactrl.loveScoreID as! NSNumber))
        self.view.addSubview(globalGameStats)
        
        setupCheckboxView()
        
        if updateGlobalGameStats
        {
            globalGameStats.addOkPoints(newGameStatsValues.0, completion: { () in
                self.globalGameStats.addLovePoints(self.newGameStatsValues.2)
                
            })
            updateGlobalGameStats = false
            datactrl.updateGameData(newGameStatsValues.0,deltaGoodPoints: newGameStatsValues.1,deltaLovePoints: newGameStatsValues.2)
            datactrl.saveGameData()
        }
        
        //DO if first load
        challengeUsersButton.transform = CGAffineTransformScale(challengeUsersButton.transform, 0.1, 0.1)
        practiceButton.transform = CGAffineTransformScale(practiceButton.transform, 0.1, 0.1)
        resultsButton.transform = CGAffineTransformScale(resultsButton.transform, 0.1, 0.1)
        adFreeButton.transform = CGAffineTransformScale(adFreeButton.transform, 0.1, 0.1)
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.challengeUsersButton.transform = CGAffineTransformIdentity
            self.practiceButton.transform = CGAffineTransformIdentity
            self.resultsButton.transform = CGAffineTransformIdentity
            self.adFreeButton.transform = CGAffineTransformIdentity
            }, completion: { (value: Bool) in
        })
        //END DO
    }
    
    
    override func viewDidLayoutSubviews() {
        
        bannerView?.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 44, UIScreen.mainScreen().bounds.size.width, 44)
        loadingDataView?.frame =  CGRectMake(50, 50, 200, 50)
        
        setupFirstLevelMenu()

        setupChallengeTypeButtons()
        
        setupDynamicPlayButton()
    }
    
    func setupFirstLevelMenu()
    {
        let marginButtons:CGFloat = 10
        var buttonWidth = UIScreen.mainScreen().bounds.size.width * 0.17
        var buttonHeight = buttonWidth //UIScreen.mainScreen().bounds.size.height * 0.34
        challengeUsersButton.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - buttonWidth - (marginButtons / 2), UIScreen.mainScreen().bounds.size.height * 0.15, buttonWidth, buttonHeight)
        practiceButton.frame = CGRectMake(challengeUsersButton.frame.maxX + marginButtons, UIScreen.mainScreen().bounds.size.height * 0.15, buttonWidth, buttonHeight)
        
        resultsButton.frame = CGRectMake(challengeUsersButton.frame.minX, challengeUsersButton.frame.maxY + marginButtons, buttonWidth, buttonHeight)
        
        adFreeButton.frame = CGRectMake(practiceButton.frame.minX, resultsButton.frame.minY, buttonWidth, buttonHeight)
    }
    
    func setupDynamicPlayButton()
    {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        let sliderAndFilterbuttonHeight:CGFloat = 31.0
        

        var playbuttonWidth = self.practiceButton.frame.maxX - self.challengeUsersButton.frame.minX
        var playbuttonHeight = self.resultsButton.frame.maxY - self.challengeUsersButton.frame.minY - sliderAndFilterbuttonHeight - margin

        
        dynamicPlayButton.frame = CGRectMake(self.challengeUsersButton.frame.minX, self.challengeUsersButton.frame.minY,playbuttonWidth, playbuttonHeight)
        let marginSlider: CGFloat = dynamicPlayButton.frame.minX

        playButtonExstraLabel.frame = CGRectMake(0, dynamicPlayButton.frame.height * 0.7   , dynamicPlayButton.frame.width, dynamicPlayButton.frame.height * 0.15)
        playButtonExstraLabel.text = "level \(Int(levelSlider.lowerValue)) - \(sliderUpperLevelText())"
        
        levelSlider.frame = CGRect(x:  marginSlider, y: dynamicPlayButton.frame.maxY  + margin, width: UIScreen.mainScreen().bounds.size.width - (marginSlider * 2) - (dynamicPlayButton.frame.width * 0.2), height: sliderAndFilterbuttonHeight)
        
        selectFilterTypeButton.frame = CGRectMake(levelSlider.frame.maxX, dynamicPlayButton.frame.maxY + margin, UIScreen.mainScreen().bounds.size.width * 0.2, levelSlider.frame.height)
        
        dynamicPlayButton.alpha = 0
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
        //println("Range slider value changed: (\(Int(slider.lowerValue)) \(Int(slider.upperValue)))")
        playButtonExstraLabel.text = "level \(Int(slider.lowerValue)) - \(sliderUpperLevelText())"
    }
    
    func playAction()
    {
        //self.performSegueWithIdentifier("segueFromMainMenuToPlay", sender: nil)

        
    }
    
    func newChallengeAction()
    {
        dynamicPlayButton.setTitle("New challenge", forState: UIControlState.Normal)
        dynamicPlayButton.addTarget(self, action: "playNewChallengeAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.dynamicPlayButton.alpha = 0
        self.dynamicPlayButton.transform = CGAffineTransformScale(self.dynamicPlayButton.transform, 0.1, 0.1)
        self.levelSlider.alpha = 0
        self.levelSlider.transform = CGAffineTransformScale(self.levelSlider.transform, 0.1, 0.1)
        self.selectFilterTypeButton.alpha = 0
        self.selectFilterTypeButton.transform = CGAffineTransformScale(self.selectFilterTypeButton.transform, 0.1, 0.1)
        
        
        
        var centerScreen = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.newChallengeButton.center = centerScreen
            self.newChallengeButton.transform = CGAffineTransformScale(self.challengeUsersButton.transform, 0.1, 0.1)
            self.pendingChallengesButton.center = centerScreen
            self.pendingChallengesButton.transform = CGAffineTransformScale(self.practiceButton.transform, 0.1, 0.1)
            
            }, completion: { (value: Bool) in
                
                self.newChallengeButton.alpha = 0
                self.pendingChallengesButton.alpha = 0
                
                self.dynamicPlayButton.alpha = 1
                self.levelSlider.alpha = 1
                self.selectFilterTypeButton.alpha = 1
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.dynamicPlayButton.transform = CGAffineTransformIdentity
                    self.levelSlider.transform = CGAffineTransformIdentity
                    self.selectFilterTypeButton.transform = CGAffineTransformIdentity
                    }, completion: { (value: Bool) in
                        
                        
                })
        })
    }
    
    
    
    func practiceAction()
    {
        dynamicPlayButton.setTitle("Practice", forState: UIControlState.Normal)
        dynamicPlayButton.addTarget(self, action: "playPracticeAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.dynamicPlayButton.alpha = 0
        self.dynamicPlayButton.transform = CGAffineTransformScale(self.dynamicPlayButton.transform, 0.1, 0.1)
        self.levelSlider.alpha = 0
        self.levelSlider.transform = CGAffineTransformScale(self.levelSlider.transform, 0.1, 0.1)
        self.selectFilterTypeButton.alpha = 0
        self.selectFilterTypeButton.transform = CGAffineTransformScale(self.selectFilterTypeButton.transform, 0.1, 0.1)
        
        
        
        var centerScreen = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.challengeUsersButton.center = centerScreen
            self.challengeUsersButton.transform = CGAffineTransformScale(self.challengeUsersButton.transform, 0.1, 0.1)
            self.practiceButton.center = centerScreen
            self.practiceButton.transform = CGAffineTransformScale(self.practiceButton.transform, 0.1, 0.1)
            self.resultsButton.center = centerScreen
            self.resultsButton.transform = CGAffineTransformScale(self.resultsButton.transform, 0.1, 0.1)
            self.adFreeButton.center = centerScreen
            self.adFreeButton.transform = CGAffineTransformScale(self.adFreeButton.transform, 0.1, 0.1)
            
            }, completion: { (value: Bool) in
                
                self.challengeUsersButton.alpha = 0
                self.practiceButton.alpha = 0
                self.resultsButton.alpha = 0
                self.adFreeButton.alpha = 0
                
                self.dynamicPlayButton.alpha = 1
                self.levelSlider.alpha = 1
                self.selectFilterTypeButton.alpha = 1
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.dynamicPlayButton.transform = CGAffineTransformIdentity
                    self.levelSlider.transform = CGAffineTransformIdentity
                    self.selectFilterTypeButton.transform = CGAffineTransformIdentity
                    }, completion: { (value: Bool) in
                        
                        
                })
        })
    }

    
    
    func playPracticeAction()
    {
        gametype = gameType.training
        self.performSegueWithIdentifier("segueFromMainMenuToPlay", sender: nil)
    }
    
    func playNewChallengeAction()
    {
        gametype = gameType.makingChallenge
        self.performSegueWithIdentifier("segueFromMainMenuToChallenge", sender: nil)
    }
    
    func pendingChallengesAction()
    {
        gametype = gameType.takingChallenge
        self.performSegueWithIdentifier("segueFromMainMenuToChallenge", sender: nil)
    }
    
    func setupChallengeTypeButtons()
    {
        newChallengeButton.alpha = 0
        pendingChallengesButton.alpha = 0
        let buttonHeight = self.resultsButton.frame.maxY - self.challengeUsersButton.frame.minY
        newChallengeButton.frame = CGRectMake(self.challengeUsersButton.frame.minX, self.challengeUsersButton.frame.minY, self.challengeUsersButton.frame.width, buttonHeight)
        pendingChallengesButton.frame = CGRectMake(self.practiceButton.frame.minX, self.challengeUsersButton.frame.minY, self.challengeUsersButton.frame.width, buttonHeight)

    }
    
    func resultAction()
    {
        self.performSegueWithIdentifier("segueFromResultsToMainMenu", sender: nil)
    }
    
    func challengeAction()
    {

        self.newChallengeButton.transform = CGAffineTransformScale(self.newChallengeButton.transform, 0.1, 0.1)
        self.pendingChallengesButton.transform = CGAffineTransformScale(self.pendingChallengesButton.transform, 0.1, 0.1)
        var centerScreen = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            
            self.challengeUsersButton.center = centerScreen
            self.challengeUsersButton.transform = CGAffineTransformScale(self.challengeUsersButton.transform, 0.1, 0.1)
            self.practiceButton.center = centerScreen
            self.practiceButton.transform = CGAffineTransformScale(self.practiceButton.transform, 0.1, 0.1)
            self.resultsButton.center = centerScreen
            self.resultsButton.transform = CGAffineTransformScale(self.resultsButton.transform, 0.1, 0.1)
            self.adFreeButton.center = centerScreen
            self.adFreeButton.transform = CGAffineTransformScale(self.adFreeButton.transform, 0.1, 0.1)
            
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
            var svc = segue!.destinationViewController as! PlayViewController
            svc.levelLow = Int(levelSlider.lowerValue)
            svc.levelHigh = Int(levelSlider.upperValue)
            svc.tags = self.tags
            svc.gametype = gametype
        }
        
        if (segue.identifier == "segueFromMainMenuToChallenge") {
            var svc = segue!.destinationViewController as! ChallengeViewController
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
        self.bannerView?.hidden = true
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
    
}

