//
//  TransitionOperation+Action.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 30/05/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import Foundation

internal extension TransitionOperation {
    
    /// Action that occurs in an operation.
    struct Action {
        
        /// The page start index.
        let startIndex: Int
        /// The page end index.
        let endIndex: Int
        /// The direction of travel.
        let direction: NavigationDirection
        /// The semantic direction of travel. In RtL languages,
        /// this will be the opposite of direction on the horizontal axis.
        let semanticDirection: NavigationDirection
        /// The orientation of the page view controller.
        let orientation: UIPageViewController.NavigationOrientation
        
    }
}

internal extension TransitionOperation.Action {
    
    /// Animation sub-type for the action.
    var transitionSubType: String {
        switch orientation {
            
        case .horizontal:
            switch semanticDirection {
                
            case .reverse:
                return convertFromCATransitionSubtype(CATransitionSubtype.fromLeft)
            default:
                return convertFromCATransitionSubtype(CATransitionSubtype.fromRight)
            }
            
        case .vertical:
            switch semanticDirection {
                
            case .reverse:
                return convertFromCATransitionSubtype(CATransitionSubtype.fromBottom)
            default:
                return convertFromCATransitionSubtype(CATransitionSubtype.fromTop)
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromCATransitionSubtype(_ input: CATransitionSubtype) -> String {
	return input.rawValue
}
