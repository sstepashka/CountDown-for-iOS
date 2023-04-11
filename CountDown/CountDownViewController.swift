//
//  ViewController.swift
//  CountDown
//
//  Created by Dmitrii Kuragin on 12/02/2017.
//  Copyright © 2023 Dmitrii Kuragin. All rights reserved.
//

import UIKit
import AudioToolbox
import SwiftUI
import Foundation

class CountDownViewController: UIViewController {
    @IBOutlet var timeLabel: CountDownTimeLabel!
    
    var timer: CountDownTimer!
    
    private var vibrate = Sounds.settings.vibrate

    override func loadView() {
        super.loadView()
        
        timer = CountDownTimer(update: { [unowned self] timeInterval in
            timeLabel.timeInterval = timeInterval
        })
        
        timeLabel.timeInterval = timer.timeInterval
    }
    
    @IBAction func showSettings(sender: Any) {
        timer.stop()
        
        self.present(UIHostingController(rootView: SettingsView(vibration: Binding(get: {
            return Sounds.settings.vibrate
        }, set: { vibrate in
            Sounds.settings.vibrate = vibrate
        }))), animated: true);
    }
    
    @IBAction func toggle(sender: Any) {
        timer.toggle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        vibrate = Sounds.settings.vibrate
    }
}

extension CountDownViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
}

