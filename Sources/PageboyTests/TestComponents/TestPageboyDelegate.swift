//
//  TestPageboyDelegate.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import Foundation
import Pageboy

class TestPageboyDelegate: PageboyViewControllerDelegate {
    
    var lastRecordedPagePosition: CGPoint?
    var lastRecordedPageIndex: Int?
    var lastRecordedDirection: NavigationDirection?
    
    var lastWillScrollToPageAnimated: Bool?
    var lastDidScrollToPositionAnimated: Bool?
    var lastDidScrollToPageAtIndexAnimated: Bool?

    var lastDidReloadPageCount: Int?
    var lastDidReloadCurrentViewController: UIViewController?
    var lastDidReloadCurrentIndex: PageIndex?
    var reloadCount: Int = 0
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               willScrollToPageAt index: PageIndex,
                               direction: NavigationDirection,
                               animated: Bool) {
        lastWillScrollToPageAnimated = animated
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollTo position: CGPoint,
                               direction: NavigationDirection,
                               animated: Bool) {
        lastDidScrollToPositionAnimated = animated
        lastRecordedPagePosition = position
        lastRecordedDirection = direction
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageAt index: PageIndex,
                               direction: NavigationDirection,
                               animated: Bool) {
        lastDidScrollToPageAtIndexAnimated = animated
        lastRecordedPageIndex = index
        lastRecordedDirection = direction
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didReloadWith currentViewController: UIViewController,
                               currentPageIndex: PageIndex) {
        lastDidReloadPageCount = pageboyViewController.pageCount
        lastDidReloadCurrentViewController = currentViewController
        lastDidReloadCurrentIndex = currentPageIndex
        
        reloadCount += 1
    }
}
