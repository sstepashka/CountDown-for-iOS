//
//  NSLayoutConstraintExtensions.swift
//  CountDown
//
//  Created by Dmitrii Kuragin on 12/02/2017.
//  Copyright © 2023 Dmitrii Kuragin. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element: NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    func constraints(_ format: String, options opts: NSLayoutConstraint.FormatOptions = [], metrics: [String : Any]? = .none, views: [String : Any]) -> [NSLayoutConstraint] {
        return self + type(of: self).constraints(format, options: opts, metrics: metrics, views: views)
    }
    
    static func constraints(_ format: String, options opts: NSLayoutConstraint.FormatOptions = [], metrics: [String : Any]? = .none, views: [String : Any]) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: format, options: opts, metrics: metrics, views: views)
    }
}
