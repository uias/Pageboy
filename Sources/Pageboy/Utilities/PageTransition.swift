//
//  PageTransition.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 29/05/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

internal protocol PageTransitionDelegate: class {
    
    func pageTransition(_ transition: PageTransition,
                        didFinish finished: Bool)
    
    func pageTransition(_ transition: PageTransition,
                        didUpdateWith percentComplete: CGFloat)
}

internal class PageTransition: NSObject, CAAnimationDelegate {
    
    public enum Style {
        case push
    }
    
    let style: Style
    private var animation: CATransition
    private var isAnimating: Bool = false
    
    internal weak var delegate: PageTransitionDelegate?
    
    private(set) var startTime: CFTimeInterval?
    
    init(with style: Style) {
        self.style = style
        
        let animation = CATransition()
        animation.duration = 1.0
        animation.startProgress = 0.0
        animation.endProgress = 1.0
        animation.type = "push"
        animation.subtype = kCATransitionFromRight
        animation.fillMode = kCAFillModeBackwards
        self.animation = animation
        
        super.init()
        
        animation.delegate = self
    }
    
    /// Start the transition animation on a layer.
    ///
    /// - Parameter layer: The layer to animate.
    func start(on layer: CALayer) {
        self.startTime = CACurrentMediaTime()
        layer.add(self.animation,
                  forKey: "transition")
    }
    
    /// Perform a frame tick on the transition.
    func tick() {
        guard isAnimating else { return }
        delegate?.pageTransition(self, didUpdateWith: percentComplete)
    }
    
    /// The total duration of the transition.
    var duration: CFTimeInterval {
        return animation.duration
    }
    /// The percent that the transition is complete.
    var percentComplete: CGFloat {
        guard self.isAnimating else { return 0.0 }
        
        let percent = CGFloat((CACurrentMediaTime() - (startTime ?? CACurrentMediaTime())) / duration)
        return max(0.0, min(1.0, percent))
    }
    
    // MARK: CAAnimationDelegate
    
    public func animationDidStart(_ anim: CAAnimation) {
        isAnimating = true
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        isAnimating = false
        delegate?.pageTransition(self, didFinish: flag)
    }
}

