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
                           completion: TransitionCompletion) {
        guard animated == true else { return }
        guard self.activeTransition == nil else { return }
        
        self.activeTransition = PageTransition(with: self.transitionStyle)
        self.activeTransition?.delegate = self
        self.transitionDisplayLink?.isPaused = false
        
        self.activeTransition?.start(on: self.pageViewController.view.layer)
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
        print(percentComplete)
    }
}
