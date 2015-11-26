//
//  StaticValues.swift
//  TimeIt
//
//  Created by knut on 18/07/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit

struct GlobalConstants {
    static let rectangleWidth:CGFloat = 200.0
    static let rectangleHeight:CGFloat = 50.0

    static let lowPercentWindow = 0.1
    static let highPercentWindow = 0.2

    static let minLevel:Int = 1
    static let maxLevel:Int = 3

    static let minWayBack:Int32 = -570000000
    static let maxWayBack:Int32 = -1000000
    static let aMillion:Int32 = 1000000

    static let smallButtonSide:CGFloat = 40
    
    static let maxNumDropZones:Int = 6
    static let minNumDropZones:Int = 3
    
    //_? CHANGE TO 7 FOR RELEASE
    static let numOfQuestionsForRound:Int = 3
}
enum EventType: Int
{
    case singleYear = 0,periode
}

enum GameType: Int
{
    case training = 0, makingChallenge = 1, takingChallenge = 2
}