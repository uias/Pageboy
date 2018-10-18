//
//  PageboyAutoScroller.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 08/03/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import Foundation

/// Internal protocol for handling auto scroller events.
internal protocol PageboyAutoScrollerHandler: class {
    
    /// Auto scroller requires a scroll.
    ///
    /// - Parameter autoScroller: The auto scroller.
    /// - Parameter animated: Whether the scroll should be animated.
    func autoScroller(didRequestAutoScroll autoScroller: PageboyAutoScroller, animated: Bool)
}

/// Delegate protocol for observing auto scroll events.
public protocol PageboyAutoScrollerDelegate: class {
    
    /// The auto scroller will begin a scroll animation on the page view controller.
    ///
    /// - Parameter autoScroller: The auto scroller.
    func autoScroller(willBeginScrollAnimation autoScroller: PageboyAutoScroller)
    
    /// The auto scroller did finish a scroll animation on the page view controller.
    ///
    /// - Parameter autoScroller: The auto scroller.
    func autoScroller(didFinishScrollAnimation autoScroller: PageboyAutoScroller)
}

/// Object that provides auto scrolling framework to PageboyViewController
public class PageboyAutoScroller: Any {
    
    // MARK: Types
    
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
    
    /// The timer
    fileprivate var timer: Timer?
    
    /// Whether the auto scroller is enabled.
    public private(set) var isEnabled: Bool = false
    /// Whether the auto scroller was previously cancelled
    internal var wasCancelled: Bool?
    /// Whether a scroll animation is currently active.
    internal fileprivate(set) var isScrolling: Bool?
    
    /// The object that acts as a handler for auto scroll events.
    internal weak var handler: PageboyAutoScrollerHandler?
    
    /// The duration spent on each page during auto scrolling. Default: .short
    public private(set) var intermissionDuration: IntermissionDuration = .short
    /// Whether auto scrolling is disabled on drag of the page view controller.
    public var cancelsOnScroll: Bool = true
    /// Whether auto scrolling restarts when a page view controller scroll ends.
    public var restartsOnScrollEnd: Bool = false
    /// Whether the auto scrolling transitions should be animated.
    public var animateScroll: Bool = true
    
    /// The object that acts as a delegate to the auto scroller.
    public weak var delegate: PageboyAutoScrollerDelegate?

    // MARK: State
    
    /// Enable auto scrolling behaviour.
    ///
    /// - Parameter duration: The duration that should be spent on each page.
    public func enable(withIntermissionDuration duration: IntermissionDuration? = nil) {
        guard !isEnabled else {
            return
        }
        
        if let duration = duration {
            intermissionDuration = duration
        }
        
        isEnabled = true
        createTimer(withDuration: intermissionDuration.rawValue)
    }
    
    /// Disable auto scrolling behaviour
    public func disable() {
        guard isEnabled else {
            return
        }
        
        destroyTimer()
        isEnabled = false
    }
    
    /// Cancel the current auto scrolling behaviour.
    internal func cancel() {
        guard isEnabled else {
            return
        }
        wasCancelled = true
        disable()
    }
    
    /// Restart auto scrolling behaviour if it was previously cancelled.
    internal func restart() {
        guard wasCancelled == true && !isEnabled else {
            return
        }
        
        wasCancelled = nil
        enable()
    }

    /// Pause auto scrolling temporarily
    internal func pause() {
        guard isEnabled else {
            return
        }
        destroyTimer()
    }
    
    /// Resume auto scrolling if it was previously paused
    internal func resume() {
        guard isEnabled && timer == nil else {
            return
        }
        createTimer(withDuration: intermissionDuration.rawValue)
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
    
    /// Initialize auto scrolling timer
    ///
    /// - Parameter duration: The duration for the timer.
    func createTimer(withDuration duration: TimeInterval) {
        guard timer == nil else {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: duration,
                                     target: self,
                                     selector: #selector(timerDidElapse(_:)),
                                     userInfo: nil, repeats: true)
    }
    
    /// Remove auto scrolling timer
    func destroyTimer() {
        guard timer != nil else {
            return
        }
        
        timer?.invalidate()
        timer = nil
    }
    
    /// Called when a scroll animation is finished
    func didFinishScrollIfEnabled() {
        guard isScrolling == true else {
            return
        }
        
        isScrolling = nil
        delegate?.autoScroller(didFinishScrollAnimation: self)
    }
    
    @objc func timerDidElapse(_ timer: Timer) {
        isScrolling = true
        delegate?.autoScroller(willBeginScrollAnimation: self)
        handler?.autoScroller(didRequestAutoScroll: self, animated: animateScroll)
    }
}
