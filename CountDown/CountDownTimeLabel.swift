//
//  CountDownTimeLabel.swift
//  CountDown
//
//  Created by Kuragin Dmitriy on 12/02/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

import Foundation
import UIKit

private let minimumTimeForRedraw = 0.0097

//class CountDownTimeLabel: UILabel {
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        adjustsFontSizeToFitWidth = true
//        super.text = .none
//    }
//    
//    @available(*, unavailable)
//    override var text: String? {
//        willSet {}
//    }
//    
//    private var prevTimeInterval: TimeInterval? = .none
//    
//    var timeInterval: TimeInterval? = .none {
//        didSet{
//            if let timeInterval = timeInterval {
//                if let prevTimeInterval = prevTimeInterval {
//                    if abs(prevTimeInterval - timeInterval) < minimumTimeForRedraw {
//                        return
//                    }
//                }
//                
//                prevTimeInterval = timeInterval
//
//                super.text = timeInterval .countDownString
//            } else {
//                super.text = .none
//            }
//        }
//    }
//}

private let defaultFont = UIFont(name: "HelveticaNeue-Light", size: 400.0)
private let defaultTextColor: UIColor = .white

@IBDesignable
class CountDownTimeLabel: UIView {
    fileprivate var label: UILabel! {
        didSet {
            self.addSubview(label)
            
            var constraits: [NSLayoutConstraint] = []
            
            constraits +=
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[label]-0-|",
                options: [],
                metrics: .none,
                views: ["label": label]
            )
            
            constraits += NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[label]-0-|",
                options: [],
                metrics: .none,
                views: ["label": label]
            )
            
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
        label.minimumScaleFactor = 0.01
        label.numberOfLines = 1
        label.backgroundColor = .clear
        
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        
        self.backgroundColor = .clear
        
        self.label = label
    }
    
    var timeInterval: TimeInterval? = .none {
        didSet{
            if let timeInterval = timeInterval {
                if let prevTimeInterval = prevTimeInterval {
                    if abs(prevTimeInterval - timeInterval) < minimumTimeForRedraw {
                        return
                    }
                }
                
                prevTimeInterval = timeInterval
                
                label.text = timeInterval .countDownString
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
