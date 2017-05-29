//
//  PageboyViewController+Transitioning.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 29/05/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

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
    
    internal func performTransition(with direction: NavigationDirection,
                           animated: Bool,
                           completion: @escaping PageTransition.Completion) {
        guard animated == true else { return }
        guard self.activeTransition == nil else { return }
        
        // create a transition and unpause display link
        self.activeTransition = PageTransition(with: self.transitionStyle,
                                               delegate: self)
        self.transitionDisplayLink?.isPaused = false
        
        // start transition
        self.activeTransition?.start(on: self.pageViewController.view.layer,
                                     completion: completion)
    }
}

extension PageboyViewController: PageTransitionDelegate {
    
    func pageTransition(_ transition: PageTransition,
                        didFinish finished: Bool) {
        self.transitionDisplayLink?.isPaused = true
        self.activeTransition = nil
    }
    
    func pageTransition(_ transition: PageTransition,
                        didUpdateWith percentComplete: CGFloat) {
        
        let bounds = pageViewController.scrollView?.bounds.size.width ?? 0.0
        let currentPosition = CGFloat(self.currentIndex ?? 0) + percentComplete
        let point = CGPoint(x: currentPosition, y: 0.0)
        
        // TODO - Add support for orientations and direction etc.
        // TODO - Update all requisite positional values
        self.delegate?.pageboyViewController(self, didScrollToPosition: point, direction: .forward, animated: true)
    }
}
