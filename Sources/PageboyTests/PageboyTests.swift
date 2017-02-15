//
//  PageboyTests.swift
//  PageboyTests
//
//  Created by Merrick Sapsford on 04/01/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import XCTest
@testable import Pageboy

class PageboyTests: XCTestCase {
    
    var pageboyViewController: TestPageBoyViewController!
    var dataSource: TestPageboyDataSource!
    
    //
    // MARK: Environment
    //
    
    override func setUp() {
        super.setUp()
        
        self.pageboyViewController = TestPageBoyViewController()
        self.dataSource = TestPageboyDataSource()
        
        self.pageboyViewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        
        self.pageboyViewController = nil
        self.dataSource = nil
        
        super.tearDown()
    }
    
    //
    // MARK: Tests
    //
    
    func testInit() {
        XCTAssert(self.pageboyViewController != nil,
                  "PageBoyViewController initialization failed")
    }
}
