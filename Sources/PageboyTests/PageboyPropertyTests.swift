//
//  PageboyPropertyTests.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 22/03/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import XCTest
@testable import Pageboy

class PageboyPropertyTests: PageboyTests {
    
    /// Test that currentViewController property returns correct view controller.
    func testCorrectCurrentViewControllerReported() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        performAsyncTest { (completion) in
            
            self.pageboyViewController.scrollToPage(.next, animated: false) { (newViewController, animated, finished) in
                let currentViewController = self.pageboyViewController.currentViewController
                
                XCTAssertTrue(currentViewController === self.dataSource.viewControllers?[1],
                              "currentViewController property is incorrect following transitions.")
                completion()
            }
        }
    }
    
    /// Test that setting isScrollEnabled updates internal scroll view correctly.
    func testIsScrollEnabledUpdates() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        self.pageboyViewController.isScrollEnabled = false
        
        XCTAssertTrue(self.pageboyViewController.pageViewController?.scrollView?.isScrollEnabled == false,
                      "isScrollEnabled does not update the internal scrollView correctly.")
    }
    
//    func testPageViewControllerOptions() {
//        self.dataSource.numberOfPages = 5
//        self.pageboyViewController.dataSource = self.dataSource
//        
//        self.pageboyViewController.interPageSpacing = 12.0
//        
//        XCTAssert(self.pageboyViewController.pageViewControllerOptions?.count ?? 0 > 0,
//                  "Custom UIPageViewController options are not being passed.")
//    }
}
