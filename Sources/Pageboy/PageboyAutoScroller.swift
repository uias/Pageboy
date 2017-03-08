//
//  PageboyAutoScroller.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 08/03/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import Foundation

/// Internal protocol for handling auto scroller events.
internal protocol PageboyAutoScrollerDelegate {
    
    /// Auto scroller requires a scroll.
    ///
    /// - Parameter autoScroller: The auto scroller.
    func autoScroller(didRequestAutoScroll autoScroller: PageboyAutoScroller)
}

/// Object that provides auto scrolling framework to PageboyViewController
public class PageboyAutoScroller: Any {
    
    /// Duration spent on each page.
    ///
    /// - short: Short (5 seconds)
    /// - long: Long (10 seconds)
    /// - custom: Custom duration
    public enum IntermissionDuration {
        case short
        case long
        case custom(duration: TimeInterval)
    }

    // MARK: Properties
    
    fileprivate var timer: Timer?
    private var isEnabled: Bool = false
    internal var delegate: PageboyAutoScrollerDelegate?
    
    /// The duration spent on each page during auto scrolling.
    private(set) public var intermissionDuration: IntermissionDuration = .short
    /// Whether auto scrolling is disabled on drag of a scroll view.
    public var cancelsOnDrag: Bool = true
    
    // MARK: State
    
    /// Enable auto scrolling behaviour.
    ///
    /// - Parameter duration: The duration that should be spent on each page.
    public func enable(withIntermissionDuration duration: IntermissionDuration? = nil) {
        guard !self.isEnabled else {
            return
        }
        
        if let duration = duration {
            self.intermissionDuration = duration
        }
        
        self.isEnabled = true
        self.createTimer(withDuration: self.intermissionDuration.rawValue)
    }
    
    /// Disable auto scrolling behaviour
    public func disable() {
        guard self.isEnabled else {
            return
        }
        
        self.destroyTimer()
        self.isEnabled = false
    }
}

// MARK: - Intervals
internal extension PageboyAutoScroller.IntermissionDuration {
    var rawValue: TimeInterval {
        switch self {
        case .short:
            return 5.0
        case .long:
            return 10.0
        case .custom(let duration):
            return duration
        }
    }
}

// MARK: - Timer
internal extension PageboyAutoScroller {
    
    func createTimer(withDuration duration: TimeInterval) {
        guard self.timer == nil else {
            return
        }
        
        self.timer = Timer.scheduledTimer(timeInterval: duration,
                                          target: self,
                                          selector: #selector(timerDidElapse(_:)),
                                          userInfo: nil, repeats: true)
    }
    
    func destroyTimer() {
        guard self.timer != nil else {
            return
        }
        
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func timerDidElapse(_ timer: Timer) {
        self.delegate?.autoScroller(didRequestAutoScroll: self)
    }
}
