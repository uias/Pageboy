//
//  PageboyTransitionTests.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import XCTest
@testable import Pageboy

class PageboyTransitionTests: PageboyTests {

    /// Test transition to a valid custom PageIndex non-animated
    func testSuccessfulTransitionToCustomIndex() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        let transitionIndex = 2
        
        self.pageboyViewController.scrollToPage(.atIndex(index: transitionIndex), animated: false)
        
        XCTAssert(self.pageboyViewController.currentIndex == transitionIndex,
                  "Not transitioning to valid custom index correctly (Non animated).")
    }
    
    /// Test transition to a valid custom PageIndex animated
    func testSuccessfulTransitionToCustomIndexAnimated() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        let transitionIndex = 3
        
        self.pageboyViewController.scrollToPage(.atIndex(index: transitionIndex), animated: true)
        { (newViewController, animated, finished) in
            XCTAssert(self.pageboyViewController.currentIndex == transitionIndex,
                      "Not transitioning to valid custom index correctly (Animated).")
        }
    }
    
    /// Test attempting transition to an out of bounds custom PageIndex
    func testHandlingTransitionToOutOfBoundsCustomIndex() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        let transitionIndex = 6
        
        self.pageboyViewController.scrollToPage(.atIndex(index: transitionIndex), animated: false)
        
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
        
        self.pageboyViewController.scrollToPage(.last, animated: false)
        
        XCTAssert(self.pageboyViewController.currentIndex == 4,
                  "Not transitioning to last index correctly.")
    }
    
    /// Test transition to a .next PageIndex
    func testSuccessfulTransitionToNextIndex() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        self.pageboyViewController.scrollToPage(.next, animated: false)
        
        XCTAssert(self.pageboyViewController.currentIndex == 1,
                  "Not transitioning to next index correctly.")
    }
    
    /// Test transition to a .previous PageIndex
    func testSuccessfulTransitionToPreviousIndex() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        self.pageboyViewController.scrollToPage(.last, animated: false)
        self.pageboyViewController.scrollToPage(.previous, animated: false)
        
        XCTAssert(self.pageboyViewController.currentIndex == 3,
                  "Not transitioning to previous index correctly.")
    }
    
    /// Test successful transition reports offsets correctly.
    func testSuccessfulTransitionOffsetReporting() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        self.pageboyViewController.scrollToPage(.atIndex(index: 1), animated: true)
        { (newViewController, animated, finished) in
            
            XCTAssert(self.delegate.lastRecordedPagePosition?.x == 1.0 &&
                self.delegate.lastRecordedPageIndex == 1 &&
                self.pageboyViewController.currentIndex == 1,
                      "Not reporting complete transition offset values correctly.")
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
    
    /// Test successful transition reports direction correctly.
    func testSuccessfulTransitionDirectionReporting() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        self.pageboyViewController.scrollToPage(.last, animated: false)
        self.pageboyViewController.scrollToPage(.atIndex(index: 0), animated: true)
        { (newViewController, animated, finished) in
            
            XCTAssert(self.pageboyViewController.currentIndex == 0 &&
                      self.delegate.lastRecordedDirection == .reverse,
                      "Not reporting complete transition direction values correctly")
        }
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
    
    /// Test unsuccessful animated transition to current page.
    func testUnsuccessfulTransitionToCurrentPage() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource

        self.pageboyViewController.scrollToPage(.first, animated: true) { (viewController, animated, finished) in
            XCTAssert(finished == false && self.pageboyViewController.currentIndex == 0,
                      "Not handling unsuccessful transition to current page correctly.")
        }
    }
    
    /// Test animated flags are correct for animated transitions.
    func testAnimatedTransitionAnimatedFlags() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        let transitionIndex = 3
        
        self.pageboyViewController.scrollToPage(.atIndex(index: transitionIndex), animated: true)
        { (newViewController, animated, finished) in
            
            XCTAssert(self.pageboyViewController.currentIndex == transitionIndex &&
                      self.delegate.lastWillScrollToPageAnimated == true &&
                      self.delegate.lastDidScrollToPageAtIndexAnimated == true &&
                      self.delegate.lastDidScrollToPositionAnimated == true,
                      "Animated flags for an animated scrollToPage are incorrect.")
        }
    }
    
    /// Test animated flags are correct for non-animated transitions.
    func testNonAnimatedTransitionAnimatedFlags() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        let transitionIndex = 3
        
        self.pageboyViewController.scrollToPage(.atIndex(index: transitionIndex), animated: false)
        { (newViewController, animated, finished) in
            
            XCTAssert(self.pageboyViewController.currentIndex == transitionIndex &&
                self.delegate.lastWillScrollToPageAnimated == false &&
                self.delegate.lastDidScrollToPageAtIndexAnimated == false &&
                self.delegate.lastDidScrollToPositionAnimated == false,
                      "Animated flags for an non animated scrollToPage are incorrect.")
        }
    }
    
    // MARK: Utils
    
    func simulateScroll(toPosition position: CGFloat) {
        let targetIndex = Int(position.rounded())
        
        let boundsWidth = self.pageboyViewController.view.frame.size.width
        self.pageboyViewController.expectedTransitionIndex = targetIndex
        self.pageboyViewController.pageViewController.scrollView?.setContentOffset(CGPoint(x: boundsWidth + (boundsWidth * position), y: 0.0),
                                                                                   animated: false)
    }
}
