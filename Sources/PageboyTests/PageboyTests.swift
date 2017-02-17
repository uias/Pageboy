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
    var delegate: TestPageboyDelegate!
    
    //
    // MARK: Environment
    //
    
    override func setUp() {
        super.setUp()
        
        self.pageboyViewController = TestPageBoyViewController()
        self.dataSource = TestPageboyDataSource()
        self.delegate = TestPageboyDelegate()
        
        self.pageboyViewController.loadViewIfNeeded()
        self.pageboyViewController.delegate = delegate
        
        let bounds = UIScreen.main.bounds
        self.pageboyViewController.view.frame = bounds
    }
    
    override func tearDown() {
        
        self.pageboyViewController = nil
        self.dataSource = nil
        self.delegate = nil
        
        super.tearDown()
    }
    
    //
    // MARK: Tests
    //
    
    private func testInit() {
        XCTAssert(self.pageboyViewController != nil,
                  "PageBoyViewController initialization failed")
    }
}
