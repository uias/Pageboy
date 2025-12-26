//
//  PageboyConfigurationTests.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2022 UI At Six. All rights reserved.
//

import XCTest
@testable import Pageboy

class PageboyConfigurationTests: PageboyTestCase {
    
    /// Test updating navigationOrientation updates pageViewController correctly.
    func testPageboyNavigationOrientationChange() {
        self.pageboyViewController.navigationOrientation = .vertical
        
        XCTAssert(self.pageboyViewController.pageViewController?.navigationOrientation == .vertical,
                  "Could not configure Pageboy navigationOrientation correctly")
    }
}
