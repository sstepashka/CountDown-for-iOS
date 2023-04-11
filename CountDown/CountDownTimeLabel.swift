//
//  CountDownTimeLabel.swift
//  CountDown
//
//  Created by Dmitrii Kuragin on 12/02/2017.
//  Copyright © 2023 Dmitrii Kuragin. All rights reserved.
//

import Foundation
import UIKit

private let minimumTimeForRedraw = 0.0097

private let defaultFont = UIFont(name: "HelveticaNeue-Light", size: 400.0)
private let defaultTextColor: UIColor = .white

@IBDesignable
class CountDownTimeLabel: UIView {
    fileprivate var label: UILabel! {
        didSet {
            guard let label = label else {
                fatalError("'label' didn't loaded.")
            }
            
            self.addSubview(label)
            
            let views = ["label": label]
            
            let constraits = [NSLayoutConstraint]
                .constraints("H:|-0-[label]-0-|", views: views)
                .constraints("V:|-0-[label]-0-|", views: views)
            
            constraits.activate()
        }
    }
    
    private var prevTimeInterval: TimeInterval? = .none
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultSetup()
    }
    
    func defaultSetup() {
        let label = UILabel(frame: bounds)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = defaultFont
        label.baselineAdjustment = .alignCenters
        label.textColor = defaultTextColor
        label.adjustsFontSizeToFitWidth = true
        label.text = .none
        label.textAlignment = .center
        label.minimumScaleFactor = 0.01
        label.numberOfLines = 1
        
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        
        self.backgroundColor = .clear
        
        self.label = label
    }
    
    var timeInterval: TimeInterval? = .none {
        didSet {
            if let timeInterval = timeInterval {
                label.text = timeInterval.countDownString
            } else {
                label.text = .none
            }
        }
    }
}

extension CountDownTimeLabel {
    override func prepareForInterfaceBuilder() {
        label.text = "29:98"
    }
}
