//
//  PageboyViewController+Transitioning.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 29/05/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

public extension PageboyViewController {
    
    /// Transition for a page scroll.
    struct Transition {
        
        /// Style for the transition
        ///
        /// - push: slide the new page in (Default).
        enum Style: String {
            case push = "push"
        }
        
        /// The style for the transition.
        let style: Style
        /// The duration of the transition.
        let duration: TimeInterval
        
        static var defaultTransition: Transition {
            return Transition(style: .push, duration: 0.3)
        }
    }
}

public extension PageboyViewController {
    
    // MARK: Set Up
    
    internal func setUpTransitioning() {
        guard self.transitionDisplayLink == nil else { return }
        
        let transitionDisplayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidTick))
        transitionDisplayLink.isPaused = true
        transitionDisplayLink.add(to: RunLoop.main, forMode: .commonModes)
        self.transitionDisplayLink = transitionDisplayLink
    }
    
    // MARK: Animation
    
    func displayLinkDidTick() {
        self.activeTransition?.tick()
    }
    
    internal func performTransition(from: Int,
                                    to: Int,
                                    with direction: NavigationDirection,
                                    animated: Bool,
                                    completion: @escaping TransitionOperation.Completion) {
        guard animated == true else { return }
        guard self.activeTransition == nil else { return }
        
        // create a transition and unpause display link
        let action = TransitionOperation.Action(startIndex: from,
                                                endIndex: to,
                                                direction: direction,
                                                orientation: self.navigationOrientation)
        self.activeTransition = TransitionOperation(for: self.transition,
                                                    action: action,
                                                    delegate: self)
        self.transitionDisplayLink?.isPaused = false
        
        // start transition
        self.activeTransition?.start(on: self.pageViewController.view.layer,
                                     completion: completion)
    }
}

extension PageboyViewController: TransitionOperationDelegate {
    
    func transitionOperation(_ operation: TransitionOperation,
                             didFinish finished: Bool) {
        self.transitionDisplayLink?.isPaused = true
        self.activeTransition = nil
    }
    
    func transitionOperation(_ operation: TransitionOperation,
                             didUpdateWith percentComplete: CGFloat) {
        
        let isReverse = operation.action.direction == .reverse
        let isVertical = operation.action.orientation == .vertical
        
        let currentIndex = CGFloat(self.currentIndex ?? 0)
        let currentPosition = isReverse ? currentIndex - percentComplete : currentIndex + percentComplete
        let point = CGPoint(x: isVertical ? 0.0 : currentPosition,
                            y: isVertical ? currentPosition : 0.0)
        
        self.currentPosition = point
        self.delegate?.pageboyViewController(self, didScrollToPosition: point,
                                             direction: operation.action.direction,
                                             animated: true)
        self.previousPagePosition = currentPosition
    }
}

internal extension PageboyViewController.Transition {
    
    func configure(transition: inout CATransition) {
        transition.duration = self.duration
        transition.type = self.style.rawValue
    }
}
