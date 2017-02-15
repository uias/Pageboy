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
        
        self.pageboyViewController.transitionToPage(.atIndex(index: transitionIndex), animated: false)
        
        XCTAssert(self.pageboyViewController.currentIndex == transitionIndex,
                  "Not transitioning to valid custom index correctly (Non animated).")
    }
    
    /// Test transition to a valid custom PageIndex animated
    func testSuccessfulTransitionToCustomIndexAnimated() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        let transitionIndex = 3
        
        self.pageboyViewController.transitionToPage(.atIndex(index: transitionIndex), animated: true)
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
        
        self.pageboyViewController.transitionToPage(.atIndex(index: transitionIndex), animated: false)
        
        XCTAssert(self.pageboyViewController.currentIndex == 0,
                  "Not handling out of bounds transition index request correctly.")
    }
    
    /// Test transition to a .first PageIndex
    func testSuccessfulTransitionToFirstIndex() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        self.pageboyViewController.transitionToPage(.first, animated: false)
        
        XCTAssert(self.pageboyViewController.currentIndex == 0,
                  "Not transitioning to first index correctly.")
    }
    
    /// Test transition to a .last PageIndex
    func testSuccessfulTransitionToLastIndex() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        self.pageboyViewController.transitionToPage(.last, animated: false)
        
        XCTAssert(self.pageboyViewController.currentIndex == 4,
                  "Not transitioning to last index correctly.")
    }
    
    /// Test transition to a .next PageIndex
    func testSuccessfulTransitionToNextIndex() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        self.pageboyViewController.transitionToPage(.next, animated: false)
        
        XCTAssert(self.pageboyViewController.currentIndex == 1,
                  "Not transitioning to next index correctly.")
    }
    
    /// Test transition to a .previous PageIndex
    func testSuccessfulTransitionToPreviousIndex() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        
        self.pageboyViewController.transitionToPage(.last, animated: false)
        self.pageboyViewController.transitionToPage(.previous, animated: false)
        
        XCTAssert(self.pageboyViewController.currentIndex == 3,
                  "Not transitioning to previous index correctly.")
    }
}
