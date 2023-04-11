//
//  TimeIntervalExtensions.swift
//  CountDown
//
//  Created by Dmitrii Kuragin on 12/02/2017.
//  Copyright © 2023 Dmitrii Kuragin. All rights reserved.
//

import Foundation

internal protocol TimeIntervalProvider {
    func now() -> TimeInterval
}

fileprivate class NSDateTimeIntervalProvider: TimeIntervalProvider {
    func now() -> TimeInterval {
        return NSDate.timeIntervalSinceReferenceDate
    }
}

internal var defaultTimeIntervalProvider: TimeIntervalProvider = NSDateTimeIntervalProvider()

extension TimeInterval {
    static func now() -> TimeInterval {
        return defaultTimeIntervalProvider.now()
    }
}

extension TimeInterval {
    var seconds: Int {
        return Int(floor(self))
    }
    
    var fraction: Int {
        return Int(floor((self - floor(self)) * 100))
    }
}

extension TimeInterval {
    var countDownString: String {
        let seconds = self.seconds
        let fraction = self.fraction
        
        return String(format: "%02d:%02d", seconds, fraction)
    }
}
