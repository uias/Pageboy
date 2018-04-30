//
//  PageboyNavigationDirection.swift
//  Pageboy iOS
//
//  Created by Merrick Sapsford on 30/04/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import Foundation

public enum PageboyNavigationDirection {
    case neutral
    case forward
    case reverse
}

internal extension PageboyNavigationDirection {
    
    var rawValue: UIPageViewControllerNavigationDirection {
        switch self {
            
        case .reverse:
            return .reverse
            
        default:
            return .forward
        }
    }
    
    static func forPage(_ page: Int,
                        previousPage: Int) -> PageboyViewController.NavigationDirection {
        return self.forPosition(CGFloat(page), previous: CGFloat(previousPage))
    }
    
    static func forPosition(_ position: CGFloat,
                            previous previousPosition: CGFloat) -> PageboyViewController.NavigationDirection {
        if position == previousPosition {
            return .neutral
        }
        return  position > previousPosition ? .forward : .reverse
    }
}
