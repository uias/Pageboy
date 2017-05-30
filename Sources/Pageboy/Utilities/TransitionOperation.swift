//
//  TransitionOperation.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 29/05/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

internal protocol TransitionOperationDelegate: class {
    
    func transitionOperation(_ operation: TransitionOperation,
                             didFinish finished: Bool)
    
    func transitionOperation(_ operation: TransitionOperation,
                        didUpdateWith percentComplete: CGFloat)
}

internal class TransitionOperation: NSObject, CAAnimationDelegate {
    
    // MARK: Types
    
    typealias Completion = (Bool) -> Void
    
    // MARK: Properties
    
    let transition: PageboyViewController.Transition
    let action: Action
    
    private var animation: CATransition
    private var isAnimating: Bool = false
    
    private(set) weak var delegate: TransitionOperationDelegate?
    
    private(set) var startTime: CFTimeInterval?
    
    private var completion: Completion?
    
    // MARK: Init
    
    init(for transition: PageboyViewController.Transition,
         action: Action,
         delegate: TransitionOperationDelegate) {
        self.transition = transition
        self.action = action
        self.delegate = delegate
        
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
    /// - Parameter completion: Completion of the transition.
    func start(on layer: CALayer,
               completion: @escaping Completion) {
        self.completion = completion
        self.startTime = CACurrentMediaTime()
        layer.add(self.animation,
                  forKey: "transition")
    }
    
    /// Perform a frame tick on the transition.
    func tick() {
        guard isAnimating else { return }
        delegate?.transitionOperation(self, didUpdateWith: percentComplete)
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
        completion?(flag)
        delegate?.transitionOperation(self, didFinish: flag)
    }
}

