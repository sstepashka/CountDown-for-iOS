//
//  CountDownTests.swift
//  CountDownTests
//
//  Created by Kuragin Dmitriy on 12/02/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

import XCTest
@testable import CountDown

extension XCTestCase {
    func expectFatalError(_ expectedMessage: String = "", body: @escaping () -> Void) {
        let expectation = self.expectation(description: "Expecting 'FatalError' with message: \"\(expectedMessage)\"")
        
        let storedFatalError = Assertions.fatalError
        
        var assertionMessage: String? = .none
        Assertions.fatalError = {message, _, _ in
            assertionMessage = message
            expectation.fulfill()
        }
        
        DispatchQueue.global(qos: .userInitiated).async(execute: body)
        
        waitForExpectations(timeout: 30.0) { (error) in
            XCTAssertEqual(assertionMessage, expectedMessage)
            
            Assertions.fatalError = storedFatalError
        }
    }
}

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
    
    func testCountDownState() {
        let defaultNowTimeInterval: TimeInterval = 20.0
        
        class ConstantTimeIntervalProvider: TimeIntervalProvider {
            private let timeInterval: TimeInterval
            init(_ timeInterval: TimeInterval) {
                self.timeInterval = timeInterval
            }
            
            func now() -> TimeInterval {
                return timeInterval
            }
        }
        
        let storedTimeIntervalProvider = defaultTimeIntervalProvider
        
        defaultTimeIntervalProvider = ConstantTimeIntervalProvider(defaultNowTimeInterval)
        
        let stoppedState: CountDownState = .stopped
        
        XCTAssertEqual(stoppedState.started, false)
        
        let startTimeInterval: TimeInterval = 10.0
        let displayLinkMock = CADisplayLink()
        let startedState: CountDownState = .started(displayLinkMock, startTimeInterval)
        
        XCTAssertEqual(startedState.started, true)
        
        let downTimeInterval: TimeInterval = 30.0
        
        let elapsedTime1 = startedState.elapsedTime(downTimeInterval)
        
        XCTAssertEqual(elapsedTime1, downTimeInterval - (defaultNowTimeInterval - startTimeInterval))
        
        let downTimeInterva2: TimeInterval = 1.0
        
        let elapsedTime2 = startedState.elapsedTime(downTimeInterva2)
        
        XCTAssertEqual(elapsedTime2, 0.0)
        
        defaultTimeIntervalProvider = storedTimeIntervalProvider
    }
    
    func testFatalErrors() {
        let startTimeInterval: TimeInterval = 0.0
        let startedState: CountDownState = .started(CADisplayLink(), startTimeInterval)
        
        expectFatalError("\'downTimeInterval\' can be only greather zero") {
            _ = startedState.elapsedTime(-10.0)
        }
        
        expectFatalError("init(coder:) has not been implemented") {
            _ = BackgroundLayer(coder: NSCoder())
        }
    }
}
