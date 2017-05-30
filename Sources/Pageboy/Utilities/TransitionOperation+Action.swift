//
//  TransitionOperation+Action.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 30/05/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import Foundation

internal extension TransitionOperation {
    
    struct Action {
        
        let startIndex: Int
        let endIndex: Int
        let direction: PageboyViewController.NavigationDirection
        let orientation: UIPageViewControllerNavigationOrientation
        
    }
}

internal extension TransitionOperation.Action {
    
    var transitionSubType: String {
        switch orientation {
            
        case .horizontal:
            switch direction {
                
            case .reverse:
                return kCATransitionFromLeft
            default:
                return kCATransitionFromRight
            }
            
        case .vertical:
            switch direction {
                
            case .reverse:
                return kCATransitionFromTop
            default:
                return kCATransitionFromBottom
            }
        }
    }
}
