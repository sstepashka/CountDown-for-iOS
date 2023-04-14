//
//  TimeIntervalExtensions.swift
//  CountDown
//
//  Created by Dmitrii Kuragin on 12/02/2017.
//  Copyright © 2023 Dmitrii Kuragin. All rights reserved.
//

import Foundation

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
        return String(format: "%02d:%02d", self.seconds, self.fraction)
    }
}
