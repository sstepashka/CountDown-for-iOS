//
//  CountDownTests.swift
//  CountDownTests
//
//  Created by Dmitrii Kuragin on 12/02/2017.
//  Copyright © 2023 Dmitrii Kuragin. All rights reserved.
//

import XCTest
@testable import CountDown

import Foundation

class CountDownTests: XCTestCase {
    private var timer = MyTimer(duration: 30.0)!

    func testCreateMyTimerWithCustomDuration() {
        let _ = MyTimer(duration: 25.0)
    }

    func testFailToCreateMyTimeWithNegativeDuration() {
        XCTAssert(MyTimer(duration: -1.0) == nil)
    }

    func testFailToCreateMyTimeWithZeroDuration() {
        XCTAssert(MyTimer(duration: 0.0) == nil)
        XCTAssert(MyTimer(duration: -0.0) == nil)
    }

    func testStartTimer() {
        var timer = MyTimer(duration: 30.0)
        XCTAssert(timer != nil)
        timer!.start(now: 10.0)
    }

    func testTimeLeftReturns20When10SecondsPass() {
        timer.start(now: 5837.0)
        XCTAssertEqual(timer.timeLeft(now: 5837.0), 30.0)
    }

    func testLeftTimeAfterUpdate() {
        timer.start(now: 5837.0)

        XCTAssertEqual(timer.timeLeft(now: 5848.0), 19.0, accuracy: 0.01)
    }

    func testLeftTimeResetToDurationWhenTimerIsStopped() {
        timer.start(now: 5837.0)

        XCTAssertEqual(timer.timeLeft(now: 5848.0), 19.0, accuracy: 0.01)

        timer.stop()

        XCTAssertEqual(timer.timeLeft(now: 5849.0), 30.0, accuracy: 0.01)
    }

    func testStartedIsFalseBeforeStart() {
        XCTAssertFalse(timer.started)
    }

    func testStartedIsFalseAfterStop() {
        timer.start(now: 1234.0)
        timer.stop()
        XCTAssertFalse(timer.started)
    }

    func testStartedIsTrueAfterStart() {
        timer.start(now: 2423.0)
        XCTAssertTrue(timer.started)
    }

    func testLeftTimeWhenNotStartedEqualsToDuration() {
        XCTAssertEqual(timer.timeLeft(now: 6453.0), 30.0, accuracy: 0.01)
    }

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
