//
//  TestPageboyDelegate.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
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

    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               willScrollToPageAtIndex pageIndex: Int,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        lastWillScrollToPageAnimated = animated
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPosition pagePosition: CGPoint,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        lastDidScrollToPositionAnimated = animated
        lastRecordedPagePosition = pagePosition
        lastRecordedDirection = direction
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageAtIndex pageIndex: Int,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        lastDidScrollToPageAtIndexAnimated = animated
        lastRecordedPageIndex = pageIndex
        lastRecordedDirection = direction
    }
    
}
