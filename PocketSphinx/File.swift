//
//  File.swift
//  CountDown
//
//  Created by Kuragin Dmitriy on 14/02/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

import Foundation
import Sphinx
import Sphinx.Base
import Sphinx.Pocket

internal protocol ArgTransformable {
    func transform() -> arg_t
}

protocol ArgType {
    
}

public struct Arg: ArgType {
    public let name: String
    public let type: ArgValueType
    public let `default`: String
    public let doc: String
}

extension Arg {
    public enum ArgValueType {
        case integer
        case floating
        case string
        case boolean
        case stringList
    }
}

extension Arg.ArgValueType {
    func map() -> Int32 {
        switch self {
        case .integer:
            return ARG_INTEGER
        case .floating:
            return ARG_FLOATING
        case .string:
            return ARG_STRING
        case .boolean:
            return ARG_BOOLEAN
        case .stringList:
            return ARG_STRING_LIST
        }
    }
}

extension Arg: ArgTransformable {
    func transform() -> arg_t {
        let arg = name.withCString { (name) -> arg_t in
            return `default`.withCString { (defaultName) -> arg_t in
                return doc.withCString({ (doc) -> arg_t in
                    return arg_t(name: name, type: type.map(), deflt: defaultName, doc: doc)
                })
            }
        }

        return arg
    }
}

internal extension Array where Element: ArgType, Element: ArgTransformable {
    func transform() -> [arg_t] {
        return self.map { (arg) -> arg_t in
            return arg.transform()
        }
    }
}

class cmd {
    init() {
//        cmd_ln_int_r(<#T##cmdln: OpaquePointer!##OpaquePointer!#>, <#T##name: UnsafePointer<Int8>!##UnsafePointer<Int8>!#>)
    }
}
