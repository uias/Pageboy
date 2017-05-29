//
//  PageboyViewController+Transitioning.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 29/05/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

public extension PageboyViewController {
    
    public enum TransitionStyle {
        case push
    }
    
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
        print("tick")
    }
    
    internal func performTransition(with direction: NavigationDirection,
                           animated: Bool,
                           completion: TransitionCompletion) {
        guard animated == true else { return }
        
        let animation = CATransition()
        animation.duration = 1.0
        animation.startProgress = 0.0
        animation.endProgress = 1.0
        animation.type = "push"
        animation.subtype = direction == .reverse ? kCATransitionFromLeft : kCATransitionFromRight
        animation.fillMode = kCAFillModeBackwards
        self.pageViewController.view.layer.add(animation, forKey: nil)

        
//        completion(true)
    }
}
