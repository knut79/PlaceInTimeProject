//
//  ClockView.swift
//  PlaceInTime
//
//  Created by knut on 02/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit


protocol ClockProtocol
{
    func timeup()
}

class ClockView:UIView {
    
    var delegate:ClockProtocol?
    let clockHandLayer = CAShapeLayer()
    let circleLayer: CAShapeLayer = CAShapeLayer()
    var forceStop:Bool = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        
        let endAngle = CGFloat(2*M_PI)
        /*
        clockHandLayer.frame = self.bounds
        let secondPath = CGPathCreateMutable()
        CGPathMoveToPoint(secondPath, nil, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        //CGPathAddLineToPoint(secondPath, nil, time.s.x, time.s.y)
        CGPathAddLineToPoint(secondPath, nil, self.frame.width / 2, self.frame.minY + (self.frame.height * 0.165))

        clockHandLayer.path = secondPath
        clockHandLayer.lineWidth = 1
        clockHandLayer.lineCap = kCALineCapRound
        clockHandLayer.strokeColor = UIColor.blackColor().CGColor
        clockHandLayer.rasterizationScale = UIScreen.mainScreen().scale
        clockHandLayer.shouldRasterize = true
        self.layer.addSublayer(clockHandLayer)
        
        

        let centerPiece = CAShapeLayer()
        let circle = UIBezierPath(arcCenter: CGPoint(x:CGRectGetMidX(self.bounds),y:CGRectGetMidX(self.bounds)), radius: 4.5, startAngle: 0, endAngle: endAngle, clockwise: true)
        centerPiece.path = circle.CGPath
        centerPiece.fillColor = UIColor.blackColor().CGColor
        self.layer.addSublayer(centerPiece)
        */
        
        
        
        //let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: 0.0, endAngle: CGFloat(M_PI * 2.0), clockwise: false)
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: CGFloat(M_PI) * 90.0/180, endAngle: CGFloat(M_PI) * 90.1/180, clockwise: false)
        
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor.redColor().CGColor
        circleLayer.lineWidth = 5.0;
        
        circleLayer.strokeEnd = 0.0
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }
    
    func start()
    {
        
        //let time = timeCoords(CGRectGetMidX(self.bounds), y: CGRectGetMidY(self.bounds), time: ctime(),radius: 500)
        self.animateCircle(10.0)
        forceStop = false
        //rotateLayer(clockHandLayer,dur: 10)

    }
    
    func stop()
    {
        forceStop = true
        //clockHandLayer.removeAllAnimations()
        circleLayer.removeAllAnimations()
    }
    
    //test
    func animateCircle(duration: NSTimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = 0
        animation.toValue = 1
        animation.delegate = self
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = 1
        
        // Do the actual animation
        circleLayer.addAnimation(animation, forKey: "animateCircle")
    }
    //end test
    
    // MARK: Retrieve time
    
    func ctime ()->(h:Int,m:Int,s:Int) {
        
        var t = time_t()
        time(&t)
        let x = localtime(&t) // returns UnsafeMutablePointer
        
        return (h:Int(x.memory.tm_hour),m:Int(x.memory.tm_min),s:Int(x.memory.tm_sec))
    }
    // END: Retrieve time
    
    // MARK: Calculate coordinates of time
    func  timeCoords(x:CGFloat,y:CGFloat,time:(h:Int,m:Int,s:Int),radius:CGFloat,adjustment:CGFloat=90)->(h:CGPoint, m:CGPoint,s:CGPoint) {
        let cx = x // x origin
        let cy = y // y origin
        var r  = radius // radius of circle
        var points = [CGPoint]()
        var angle = degree2radian(6)
        func newPoint (t:Int) {
            let xpo = cx - r * cos(angle * CGFloat(t)+degree2radian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(t)+degree2radian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
        }
        // work out hours first
        var hours = time.h
        if hours > 12 {
            hours = hours-12
        }
        let hoursInSeconds = time.h*3600 + time.m*60 + time.s
        newPoint(hoursInSeconds*5/3600)
        
        // work out minutes second
        r = radius * 1.25
        let minutesInSeconds = time.m*60 + time.s
        newPoint(minutesInSeconds/60)
        
        // work out seconds last
        r = radius * 1.5
        newPoint(time.s)
        
        return (h:points[0],m:points[1],s:points[2])
    }
    
    func rotateLayer(currentLayer:CALayer,dur:CFTimeInterval){
        
        var angle = degree2radian(360)
        
        // rotation http://stackoverflow.com/questions/1414923/how-to-rotate-uiimageview-with-fix-point
        var theAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        theAnimation.duration = dur
        // Make this view controller the delegate so it knows when the animation starts and ends
        theAnimation.delegate = self
        theAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        // Use fromValue and toValue
        theAnimation.fromValue = angle
        theAnimation.repeatCount = 1 //Float.infinity
        theAnimation.toValue = 0
        // Add the animation to the layer
        currentLayer.addAnimation(theAnimation, forKey:"rotate")
        
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if !forceStop
        {
            delegate?.timeup()
        }
    }
    
    func degree2radian(a:CGFloat)->CGFloat {
        let b = CGFloat(M_PI) * a/180
        return b
    }
    
    
    func circleCircumferencePoints(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,adjustment:CGFloat=0)->[CGPoint] {
        let angle = degree2radian(360/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides {
            let xpo = cx - r * cos(angle * CGFloat(i)+degree2radian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i)+degree2radian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i--;
        }
        return points
    }
    
    func secondMarkers(#ctx:CGContextRef,x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor) {
        // retrieve points
        let points = circleCircumferencePoints(sides,x: x,y: y,radius: radius)
        // create path
        let path = CGPathCreateMutable()
        // determine length of marker as a fraction of the total radius
        var divider:CGFloat = 1/16
        for p in enumerate(points) {
            if p.index % 5 == 0 {
                divider = 1/8
            }
            else {
                divider = 1/16
            }
            
            let xn = p.element.x + divider*(x-p.element.x)
            let yn = p.element.y + divider*(y-p.element.y)
            // build path
            CGPathMoveToPoint(path, nil, p.element.x, p.element.y)
            CGPathAddLineToPoint(path, nil, xn, yn)
            CGPathCloseSubpath(path)
            // add path to context
            CGContextAddPath(ctx, path)
        }
        // set path color
        let cgcolor = color.CGColor
        CGContextSetStrokeColorWithColor(ctx,cgcolor)
        CGContextSetLineWidth(ctx, 3.0)
        CGContextStrokePath(ctx)
    }
    
    
    /*
    override func drawRect(rect:CGRect)
    {
        var startColor: UIColor = UIColor.whiteColor()
        var endColor: UIColor = UIColor.grayColor()
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        
      
        
        // obtain context
        let ctx = UIGraphicsGetCurrentContext()
        
        // decide on radius
        //let rad = CGRectGetWidth(rect)/3.5
        let rad = CGRectGetWidth(rect)/3
        
        
        let endAngle = CGFloat(2*M_PI)
        
        // add the circle to the context
        CGContextAddArc(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect), rad, 0, endAngle, 1)
        
        // set fill color
        CGContextSetFillColorWithColor(ctx,UIColor.whiteColor().CGColor)
        
        // set stroke color
        CGContextSetStrokeColorWithColor(ctx,UIColor.blackColor().CGColor)
        
        // set line width
        CGContextSetLineWidth(ctx, 2.0)

        
        // draw the path
        CGContextDrawPath(ctx, kCGPathFillStroke)

        
        CGContextDrawRadialGradient(ctx, gradient, CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)), CGFloat(1.0), CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)), rad, 0)
        
        
        //secondMarkers(ctx: ctx, x: CGRectGetMidX(rect), y: CGRectGetMidY(rect), radius: rad, sides: 60, color: UIColor.whiteColor())
        
    }
    */
}