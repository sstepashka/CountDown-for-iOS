//
//  Sounds.swift
//  CountDown
//
//  Created by Kuragin Dmitriy on 13/02/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

import Foundation

protocol SoundsSettingsType {
    var vibrate: Bool { get set }
}

extension UserDefaults: SoundsSettingsType {
    private struct Defaults {
        static let vibrate = true
    }
    private struct Keys {
        static let vibrateKey = "vibrateKey"
    }
    
    var vibrate: Bool {
        get {
            if let _ = self.object(forKey: Keys.vibrateKey) {
                return self.bool(forKey: Keys.vibrateKey)
            } else {
                return Defaults.vibrate
            }
            
        }
        
        set {
            self.set(newValue, forKey: Keys.vibrateKey)
            self.synchronize()
        }
    }
}

final class Sounds {
    static var settings: SoundsSettingsType = UserDefaults.standard
}
