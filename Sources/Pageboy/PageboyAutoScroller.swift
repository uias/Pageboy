//
//  PageboyAutoScroller.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 08/03/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import Foundation

internal protocol PageboyAutoScrollerDelegate {
    
    func autoScroller(didRequestAutoScroll autoScroller: PageboyAutoScroller)
}

public class PageboyAutoScroller: Any {
    
    public enum IntermissionDuration {
        case short
        case long
        case custom(duration: TimeInterval)
    }
    
    fileprivate var timer: Timer?
    private var isEnabled: Bool = false
    
    private(set) public var intermissionDuration: IntermissionDuration = .short
    
    internal var delegate: PageboyAutoScrollerDelegate?
    
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
    
    public func disable() {
        guard self.isEnabled else {
            return
        }
        
        self.destroyTimer()
        self.isEnabled = false
    }
}

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
