//
//  PageboyTransitionTests.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2022 UI At Six. All rights reserved.
//

import XCTest
@testable import Pageboy

class PageboyTransitionTests: PageboyTestCase {

    /// Test transition to a valid custom PageIndex non-animated
    func testSuccessfulTransitionToCustomIndex() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        let transitionIndex = 2
        
        performAsyncTest { (completion) in
            self.pageboyViewController.scrollToPage(.at(index: transitionIndex),
                                                    animated: false)
            { (newViewController, animated, finished) in
                XCTAssert(self.pageboyViewController.currentIndex == transitionIndex,
                          "Not transitioning to valid custom index correctly (Non animated).")
                completion()
            }
        }
    }
    
    /// Test attempting transition to an out of bounds custom PageIndex
    func testHandlingTransitionToOutOfBoundsCustomIndex() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        let transitionIndex = 6
        
        self.pageboyViewController.scrollToPage(.at(index: transitionIndex), animated: false)
        
        XCTAssert(self.pageboyViewController.currentIndex == 0,
                  "Not handling out of bounds transition index request correctly.")
    }
    
    /// Test transition to a .first PageIndex
    func testSuccessfulTransitionToFirstIndex() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        self.pageboyViewController.scrollToPage(.first, animated: false)
        
        XCTAssert(self.pageboyViewController.currentIndex == 0,
                  "Not transitioning to first index correctly.")
    }
    
    /// Test transition to a .last PageIndex
    func testSuccessfulTransitionToLastIndex() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        performAsyncTest { (completion) in
            self.pageboyViewController.scrollToPage(.last,
                                                    animated: false)
            { (newViewController, animated, finished) in
                XCTAssert(self.pageboyViewController.currentIndex == 4,
                          "Not transitioning to last index correctly.")
                completion()
            }
        }
    }
    
    /// Test transition to a .next PageIndex
    func testSuccessfulTransitionToNextIndex() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        performAsyncTest { (completion) in
            self.pageboyViewController.scrollToPage(.next,
                                                    animated: false)
            { (newViewController, animated, finished) in
                XCTAssert(self.pageboyViewController.currentIndex == 1,
                          "Not transitioning to next index correctly.")
                completion()
            }
        }
    }
    
    /// Test transition to a .previous PageIndex
    func testSuccessfulTransitionToPreviousIndex() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        performAsyncTest { (completion) in
            
            self.pageboyViewController.scrollToPage(.last,
                                                    animated: false)
            { (newViewController, animated, finished) in
                self.pageboyViewController.scrollToPage(.previous,
                                                        animated: false)
                { (newViewController, animated, finished) in
                    XCTAssert(self.pageboyViewController.currentIndex == 3,
                              "Not transitioning to previous index correctly.")
                    completion()
                }
            }
        }
    }
    
    /// Test partial user interacted transition reports offsets correctly.
    func testPartialTransitionOffsetReporting() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        // simulate scroll
        self.simulateScroll(toPosition: 0.5)
        
        XCTAssert(String(format:"%.1f", self.delegate.lastRecordedPagePosition?.x ?? 0.0) == "0.5" &&
            self.pageboyViewController.currentIndex == 0,
                  "Not reporting partial user interacted transition offset values correctly.")
        
    }
    
    /// Test partial user interacted transition reports direction correctly.
    func testPartialTransitionDirectionReporting() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        // simulate scroll
        self.simulateScroll(toPosition: 0.5)

        XCTAssert(self.delegate.lastRecordedDirection == .forward && self.pageboyViewController.currentIndex == 0,
                  "Not reporting partial user interacted transition direction values correctly.")
    }
    
    /// Test animated flags are correct for non-animated transitions.
    func testNonAnimatedTransitionAnimatedFlags() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        let transitionIndex = 3
        
        self.pageboyViewController.scrollToPage(.at(index: transitionIndex), animated: false)
        { (newViewController, animated, finished) in
            
            XCTAssert(self.pageboyViewController.currentIndex == transitionIndex &&
                self.delegate.lastWillScrollToPageAnimated == false &&
                self.delegate.lastDidScrollToPageAtIndexAnimated == false &&
                self.delegate.lastDidScrollToPositionAnimated == false,
                      "Animated flags for an non animated scrollToPage are incorrect.")
        }
    }
    
    /// Test bounces flag is correctly adhered to when set to false.
    func testBouncingDisabledTransition() {
        self.dataSource.numberOfPages = 2
        self.pageboyViewController.dataSource = self.dataSource
        self.pageboyViewController.bounces = false
        
        self.simulateScroll(toPosition: -0.1)
        
        XCTAssert(self.pageboyViewController.currentPosition!.x == 0.0,
                  "Bounces flag is not adhered to when setting contentOffset when false.")
    }
    
    // MARK: Utils
    
    func simulateScroll(toPosition position: CGFloat) {
        let targetIndex = Int(position.rounded())
        
        let boundsWidth = self.pageboyViewController.view.frame.size.width
        self.pageboyViewController.expectedTransitionIndex = targetIndex
        self.pageboyViewController.pageViewController?.scrollView?.setContentOffset(CGPoint(x: boundsWidth + (boundsWidth * position), y: 0.0),
                                                                                   animated: false)
    }
}
