//
//  CountDownTests.swift
//  CountDownTests
//
//  Created by Dmitrii Kuragin on 12/02/2017.
//  Copyright © 2023 Dmitrii Kuragin. All rights reserved.
//

import XCTest
@testable import CountDown


class CountDownTests: XCTestCase {
    func testTimeIntervalExtensions() {
        let timeInterval1: TimeInterval = 30.129
        
        XCTAssert(timeInterval1.seconds == 30)
        XCTAssert(timeInterval1.fraction == 12)
        
        XCTAssertEqual(timeInterval1.countDownString, "30:12")
        
        let timeInterval2: TimeInterval = 9.00
        
        XCTAssert(timeInterval2.seconds == 9)
        XCTAssert(timeInterval2.fraction == 0)
        
        XCTAssertEqual(timeInterval2.countDownString, "09:00")
    }
}
