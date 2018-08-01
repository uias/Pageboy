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
    var lastRecordedDirection: PageboyViewController.NavigationDirection?
    
    var lastWillScrollToPageAnimated: Bool?
    var lastDidScrollToPositionAnimated: Bool?
    var lastDidScrollToPageAtIndexAnimated: Bool?

    var lastDidReloadPageCount: Int?
    var lastDidReloadCurrentViewController: UIViewController?
    var lastDidReloadCurrentIndex: PageboyViewController.PageIndex?
    var reloadCount: Int = 0
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               willScrollToPageAt index: PageboyViewController.PageIndex,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        lastWillScrollToPageAnimated = animated
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollTo position: CGPoint,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        lastDidScrollToPositionAnimated = animated
        lastRecordedPagePosition = position
        lastRecordedDirection = direction
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageAt index: PageboyViewController.PageIndex,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        lastDidScrollToPageAtIndexAnimated = animated
        lastRecordedPageIndex = index
        lastRecordedDirection = direction
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didReloadWith currentViewController: UIViewController,
                               currentPageIndex: PageboyViewController.PageIndex) {
        lastDidReloadPageCount = pageboyViewController.pageCount
        lastDidReloadCurrentViewController = currentViewController
        lastDidReloadCurrentIndex = currentPageIndex
        
        reloadCount += 1
    }
}
