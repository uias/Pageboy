//
//  PageboyViewController+Transitioning.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 29/05/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

public extension PageboyViewController {
    
    struct Transition {
        
        enum Style {
            case scroll
        }
        
        let style: Style
        let duration: TimeInterval
        
        static var defaultTransition: Transition {
            return Transition(style: .scroll, duration: 0.3)
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
                                                direction: direction)
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
        
        let bounds = pageViewController.scrollView?.bounds.size.width ?? 0.0
        let currentPosition = CGFloat(self.currentIndex ?? 0) + percentComplete
        let point = CGPoint(x: currentPosition, y: 0.0)
        
        // TODO - Add support for orientations and direction etc.
        // TODO - Update all requisite positional values
        self.delegate?.pageboyViewController(self, didScrollToPosition: point, direction: .forward, animated: true)
    }
}
