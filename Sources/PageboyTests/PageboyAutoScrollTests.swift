//
//  PageboyAutoScrollTests.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 08/03/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import XCTest
@testable import Pageboy

class PageboyAutoScrollTests: PageboyTests {

    var autoScrollExpectation: XCTestExpectation?
    
    /// Test that PageboyAutoScroller enables correctly.
    func testAutoScrollEnabling() {
        self.dataSource.numberOfPages = 3
        self.pageboyViewController.dataSource = self.dataSource
        
        let currentIndex = self.pageboyViewController.currentIndex ?? 0
        let duration = self.pageboyViewController.autoScroller.intermissionDuration
        
        self.autoScrollExpectation = expectation(description: "autoScroll")
        
        self.pageboyViewController.autoScroller.delegate = self
        self.pageboyViewController.autoScroller.enable(withIntermissionDuration: .custom(duration: 3.0))
        
        self.waitForExpectations(timeout: duration.rawValue) { (error) in
            XCTAssertNil(error, "Something went wrong")
            XCTAssert(self.pageboyViewController.currentIndex == currentIndex + 1,
                      "PageboyAutoScroller does not auto scroll correctly when enabled.")
        }
    }
    /// Test that PageboyAutoScroller supports cancellation.
    func testAutoScrollCancellation() {
        self.dataSource.numberOfPages = 3
        self.pageboyViewController.dataSource = self.dataSource
        
        self.pageboyViewController.autoScroller.enable(withIntermissionDuration: .long)
        let wasEnabled = self.pageboyViewController.autoScroller.isEnabled
        self.pageboyViewController.autoScroller.cancel()
        
        XCTAssert(self.pageboyViewController.autoScroller.isEnabled == false && wasEnabled,
                  "PageboyAutoScroller does not allow cancellation correctly.")
    }
}

extension PageboyAutoScrollTests: PageboyAutoScrollerDelegate {
    
    func autoScroller(willBeginScrollAnimation autoScroller: PageboyAutoScroller) {
        
    }
    
    func autoScroller(didFinishScrollAnimation autoScroller: PageboyAutoScroller) {
        autoScrollExpectation?.fulfill()
    }
}
