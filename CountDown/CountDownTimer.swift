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

extension TimeInterval {
    var seconds: Int {
        return Int(floor(self))
    }

    var fraction: Int {
        return Int(floor((self - floor(self)) * 100))
    }
}

extension TimeInterval {
    var countDownString: String {
        return String(format: "%02d:%02d", self.seconds, self.fraction)
    }
}

struct MyTimer {
    private let duration: TimeInterval
    private var startTime: TimeInterval?

    var started: Bool {
        return startTime != nil
    }

    init?(duration: TimeInterval = 30.0) {
        if duration <= 0.0 {
            return nil
        }

        self.duration = duration
    }

    func timeLeft(now: TimeInterval) -> TimeInterval {
        guard let startTime = startTime else {
            return duration
        }

        return duration - (now - startTime)
    }

    mutating func start(now: TimeInterval) {
        startTime = now
    }

    mutating func stop() {
        startTime = nil
    }

    mutating func toggle(now: TimeInterval) {
        if startTime == nil {
            self.start(now: now)
        } else {
            self.stop()
        }
    }
}

class FrameUpdater {
    private var displayLink: CADisplayLink!
    private var listener: (() -> Void)?

    init() {
        self.displayLink = CADisplayLink(
            target: self,
            selector: #selector(FrameUpdater.display)
        )
    }

    func listen(update: @escaping () -> Void) {
        guard listener == nil else {
            return
        }

        listener = update
        self.displayLink.add(to: RunLoop.main, forMode: .default)
    }

    func stop() {
        self.displayLink.remove(from: RunLoop.main, forMode: .default)
    }

    @objc func display(sender: Any) {
        listener?()
    }
}

class IdleTimer {
    private let application = UIApplication.shared

    func enable() {
        application.isIdleTimerDisabled = false
    }

    func disable() {
        application.isIdleTimerDisabled = true
    }
}

class CountDownTimer {
    var timeInterval: TimeInterval = 30.0 {
        didSet {
            update(timeInterval)
        }
    }

    var update: (TimeInterval) -> Void

    let downTimeInterval = 5.0
    private var vibrate = Sounds.settings.vibrate
    private let systemSoundID: SystemSoundID = 1022 //1104
    private let idleTimer = IdleTimer()

    private var frameUpdater = FrameUpdater()

    private var mTimer: MyTimer

    init(update: @escaping (TimeInterval) -> Void) {
        self.update = update
        mTimer = MyTimer(duration: downTimeInterval)!
    }

    func start() {
        mTimer.start(now: self.now())
        idleTimer.disable()
        frameUpdater.listen {
            self.display()
        }
        playStart()
    }

    func stop() {
        mTimer.stop()
        idleTimer.enable()
    }

    @objc func display() {
        let left = mTimer.timeLeft(now: self.now())
        timeInterval = max(0.0, left)

        if left <= 0.0 {
            stop()
            playStop()
        }
    }

    private func now() -> TimeInterval {
        return NSDate.timeIntervalSinceReferenceDate
    }

    func toggle() {
        if mTimer.started {
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
    @Published var vibration: Bool = false {
        didSet {
            Sounds.settings.vibrate = vibration
        }
    }

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
