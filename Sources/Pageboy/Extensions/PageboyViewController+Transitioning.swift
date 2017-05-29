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
    
    func performTransition(with direction: NavigationDirection, animated: Bool) {
        guard animated == true else { return }
        
        let animation = CATransition()
        animation.duration = 1.0
        animation.startProgress = 0.0
        animation.endProgress = 1.0
        animation.type = "push"
        animation.subtype = direction == .reverse ? kCATransitionFromLeft : kCATransitionFromRight
        animation.fillMode = kCAFillModeBackwards
        self.pageViewController.view.layer.add(animation, forKey: nil)
    }
}
