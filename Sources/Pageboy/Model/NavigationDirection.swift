//
//  PageboyNavigationDirection.swift
//  Pageboy iOS
//
//  Created by Merrick Sapsford on 30/04/2018.
//  Copyright © 2022 UI At Six. All rights reserved.
//

import UIKit

extension PageboyViewController {
 
    public enum NavigationDirection {
        case neutral
        case forward
        case reverse
    }
}
internal typealias NavigationDirection = PageboyViewController.NavigationDirection

internal extension PageboyViewController.NavigationDirection {
    
    var rawValue: UIPageViewController.NavigationDirection {
        switch self {
            
        case .reverse:
            return .reverse
            
        default:
            return .forward
        }
    }
}

internal extension NavigationDirection {

    static func forPage(_ page: Int,
                        previousPage: Int) -> NavigationDirection {
        return forPosition(CGFloat(page), previous: CGFloat(previousPage))
    }

    static func forPosition(_ position: CGFloat,
                            previous previousPosition: CGFloat) -> NavigationDirection {
        if position == previousPosition {
            return .neutral
        }
        return  position > previousPosition ? .forward : .reverse
    }

    static func forPageScroll(to newPage: Page,
                              at index: Int,
                              in pageViewController: PageboyViewController) -> NavigationDirection {
        var direction = NavigationDirection.forPage(index, previousPage: pageViewController.currentIndex ?? index)

        if pageViewController.isInfiniteScrollEnabled {
            switch newPage {
            case .next:
                direction = .forward
            case .previous:
                direction = .reverse
            default:
                break
            }
        }

        return direction
    }
}

internal extension NavigationDirection {

    func layoutNormalized(isRtL: Bool) -> NavigationDirection {
        guard isRtL else {
            return self
        }
        return self == .forward ? .reverse : .forward
    }
}
