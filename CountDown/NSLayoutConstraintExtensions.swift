//
//  NSLayoutConstraintExtensions.swift
//  CountDown
//
//  Created by Kuragin Dmitriy on 12/02/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

import Foundation
import UIKit

protocol NSLayoutConstraintCollection {
//    static func constraints(withVisualFormat format: String, options opts: NSLayoutFormatOptions, metrics: [String : Any]?, views: [String : Any]) -> Self
//    func constraints(withVisualFormat format: String, options opts: NSLayoutFormatOptions, metrics: [String : Any]?, views: [String : Any]) -> Self
//    func activate()
}

extension Array where Element: NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    func constraints(_ format: String, options opts: NSLayoutFormatOptions = [], metrics: [String : Any]? = .none, views: [String : Any]) -> [NSLayoutConstraint] {
        return self + type(of: self).constraints(format, options: opts, metrics: metrics, views: views)
    }
    
    static func constraints(_ format: String, options opts: NSLayoutFormatOptions = [], metrics: [String : Any]? = .none, views: [String : Any]) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: format, options: opts, metrics: metrics, views: views)
    }
}
