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
}
enum eventType: Int
{
    case singleYear = 0,periode
}

enum gameType: Int
{
    case training = 0, makingChallenge = 1, takingChallenge = 2
}