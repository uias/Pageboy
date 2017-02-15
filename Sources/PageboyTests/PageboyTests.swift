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
    // MARK: Tests - Set Up
    //
    
    /// Test the pageboy view controller successfully loading view controllers from the data source.
    func testPageboyViewControllerValidSetUp() {
        self.dataSource.numberOfPages = 1
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssert(self.pageboyViewController.viewControllers?.count == 1,
                  "View Controllers were not successfully loaded from the data source.")
    }
    
    /// Test the pageboy view controller successfully loading an empty view controller array from
    /// the data source.
    func testPageboyViewControllerEmptySetUp() {
        self.dataSource.numberOfPages = 0
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssert(self.pageboyViewController.viewControllers?.count == 0,
                  "Empty view controller array not successfully loaded from the data source.")
    }
    
    /// Test the pageboy view controller successfully loading a nil array from the data source.
    func testPageboyViewControllerNilSetUp() {
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssert(self.pageboyViewController.viewControllers == nil,
                  "View Controller array is not nil when data source returns nil.")
    }
    
}
