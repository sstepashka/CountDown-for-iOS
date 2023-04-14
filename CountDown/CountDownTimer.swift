//
//  CountDownTimer.swift
//  CountDown
//
//  Created by Dmitrii Kuragin on 4/10/23.
//  Copyright © 2023 Dmitrii Kuragin. All rights reserved.
//

import Foundation
import QuartzCore
import Combine
import AudioToolbox
import UIKit

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
    func elapsedTime(_ now: TimeInterval, _ downTimeInterval: TimeInterval) -> TimeInterval {
        if downTimeInterval <= 0 {
            fatalError("'downTimeInterval' can be only greather zero")
        }

        if case .started(_, let startTimeInterval) = self {
            var elapsedTime = downTimeInterval - (now - startTimeInterval)
            elapsedTime = max(elapsedTime, 0.0)

            return elapsedTime
        }

        return downTimeInterval
    }
}

class CountDownTimer{
    var timeInterval: TimeInterval = 30.0 {
        didSet {
            update(timeInterval)
        }
    }

    var update: (TimeInterval) -> Void

    let downTimeInterval = 30.0
    private var vibrate = Sounds.settings.vibrate
    private let systemSoundID: SystemSoundID = 1022 //1104
    private let application = UIApplication.shared

    private var state: CountDownState = .stopped {
        didSet {
            timeInterval = state.elapsedTime(self.now(), downTimeInterval)
        }
    }

    init(update: @escaping (TimeInterval) -> Void) {
        self.update = update
    }

    func start() {
        if self.state.started {
            return
        }

        application.isIdleTimerDisabled = true

        let displayLink = CADisplayLink(
            target: self,
            selector: #selector(CountDownTimer.display)
        )

        state = .started(displayLink, self.now())

        displayLink.add(to: RunLoop.main, forMode: .default)

        playStart()
    }

    func stop() {
        if !self.state.started {
            return
        }

        application.isIdleTimerDisabled = false

        if case .started(let displayLink, _) = state {
            displayLink.invalidate()
            state = .stopped
        } else {
            fatalError("Stopping already stopped count down")
        }
    }

    @objc func display(sender: Any) {
        if case .started(_, let startTimeInterval) = state {
            var elapsedTime = downTimeInterval - (self.now() - startTimeInterval)
            elapsedTime = max(elapsedTime, 0.0)

            timeInterval = elapsedTime

            if elapsedTime <= 0.0 {
                stop()
                playStop()
            }
        } else {
            fatalError("Expecting .started state for display")
        }
    }

    private func now() -> TimeInterval {
        return NSDate.timeIntervalSinceReferenceDate
    }

    func toggle() {
        if state.started {
            stop()
        } else {
            start()
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
}

class ViewModel: ObservableObject {
    @Published var timeInterval: String = "30.0"

    private var timer: CountDownTimer!

    init() {
        self.timer = CountDownTimer { newTimeInterval in
            self.timeInterval = newTimeInterval.countDownString
        }
    }

    func toggle() {
        self.timer.toggle()
    }
}
