//
//  Testing.swift
//  CountDown
//
//  Created by Kuragin Dmitriy on 12/02/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

import Foundation

internal typealias FatalErrorFunctionType = (String, StaticString, UInt) -> Void

internal final class Assertions {
    static let originalFatalError: FatalErrorFunctionType = { message, file, line in
        Swift.fatalError(message, file: file, line: line)
    }
    
    static var fatalError: FatalErrorFunctionType = Assertions.originalFatalError
    
    fileprivate static func unreachable()  -> Never {
        repeat {
            RunLoop.current.run()
        } while (true)
    }
}

internal func fatalError(_ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) -> Never {
    Assertions.fatalError(message(), file, line)
    Assertions.unreachable()
}
