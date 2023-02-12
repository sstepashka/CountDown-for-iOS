//
//  ViewController.swift
//  CountDown
//
//  Created by Kuragin Dmitriy on 12/02/2017.
//  Copyright © 2017 Kuragin Dmitriy. All rights reserved.
//

import UIKit
import AudioToolbox

enum CountDownState {
    case started(CADisplayLink, TimeInterval)
    case stopped
}

extension CountDownState {
    var started: Bool {
        if case .started(_, _) = self {
            return true
        }
        
        return false
    }
}

extension CountDownState {
    func elapsedTime(_ downTimeInterval: TimeInterval) -> TimeInterval {
        if downTimeInterval <= 0 {
            fatalError("'downTimeInterval' can be only greather zero")
        }
        
        if case .started(_, let startTimeInterval) = self {
            var elapsedTime = downTimeInterval - (.now() - startTimeInterval)
            elapsedTime = max(elapsedTime, 0.0)
            
            return elapsedTime
        }
        
        return downTimeInterval
    }
}

private let defaultDownTimeInterval: TimeInterval = 30.0
private let defaultRunLoop = RunLoop.main
private let defaultSystemSoundID: SystemSoundID = 1022 //1104

class CountDownViewController: UIViewController {
    @IBOutlet var timeLabel: CountDownTimeLabel!
    
    private let runLoop = defaultRunLoop
    private let downTimeInterval = defaultDownTimeInterval
    private var vibrate = Sounds.settings.vibrate
    private let systemSoundID = defaultSystemSoundID
    private let application = UIApplication.shared
    
    private var state: CountDownState = .stopped {
        didSet {
            timeLabel.timeInterval = state.elapsedTime(downTimeInterval)
        }
    }
    
    override func loadView() {
        super.loadView()

        timeLabel.timeInterval = downTimeInterval
    }
    
    @IBAction func toggle(sender: Any) {
        if state.started {
            stop()
        } else {
            start()
        }
    }
    
    private func start() {
        application.isIdleTimerDisabled = true
        
        let displayLink = CADisplayLink(
            target: self,
            selector: #selector(CountDownViewController.display)
        )
        
        state = .started(displayLink, .now())
        
        displayLink.add(to: runLoop, forMode: RunLoop.Mode.default)
        
        playStart()
    }
    
    private func stop() {
        application.isIdleTimerDisabled = false
        
        if case .started(let displayLink, _) = state {
            displayLink.invalidate()
            state = .stopped
        } else {
            fatalError("Stopping already stopped count down")
        }
    }
    
    @IBAction func display(sender: Any) {
        if case .started(_, let startTimeInterval) = state {
            var elapsedTime = downTimeInterval - (.now() - startTimeInterval)
            elapsedTime = max(elapsedTime, 0.0)
            
            timeLabel.timeInterval = elapsedTime
            
            if elapsedTime <= 0.0 {
                stop()
                playStop()
            }
        } else {
            fatalError("Expecting .started state for display")
        }
    }
    
    private func playStart() {
        play()
    }
    
    private func playStop() {
        play()
    }
    
    private func play() {
        if vibrate {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        vibrate = Sounds.settings.vibrate
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if state.started {
            stop()
        }
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

