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
    
    var lastRecordedPageOffset: CGPoint?
    var lastRecordedPageIndex: Int?
    var lastRecordedDirection: PageboyViewController.NavigationDirection?
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToOffset pageOffset: CGPoint,
                               direction: PageboyViewController.NavigationDirection) {
        lastRecordedPageOffset = pageOffset
        lastRecordedDirection = direction
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               willScrollToPageAtIndex pageIndex: Int,
                               direction: PageboyViewController.NavigationDirection) {
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageWithIndex pageIndex: Int,
                               direction: PageboyViewController.NavigationDirection) {
        lastRecordedPageIndex = pageIndex
        lastRecordedDirection = direction
    }
    
}
