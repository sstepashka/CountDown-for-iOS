//
//  BackgroundView.swift
//  CountDown
//
//  Created by Kuragin Dmitriy on 12/02/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

import Foundation
import UIKit

private let topColor = UIColor(
    red:    245.0 / 255.0,
    green:  51.0 / 255.0,
    blue:   146.0 / 255.0,
    alpha:  1.0
)

private let bottomColor = UIColor(
    red:    184.0 / 255.0,
    green:  40.0 / 255.0,
    blue:   240.0 / 255.0,
    alpha:  1.0
)

private let defaultColors = [
    topColor.cgColor,
    bottomColor.cgColor
]

class BackgroundLayer: CAGradientLayer {
    override init() {
        super.init()
        colors = defaultColors
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@IBDesignable
class BackgroundView: UIView {
    override class var layerClass: AnyClass {
        return BackgroundLayer.self
    }
}
