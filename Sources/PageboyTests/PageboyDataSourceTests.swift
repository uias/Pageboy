//
//  PageboyDataSourceTests.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import XCTest
@testable import Pageboy

class PageboyDataSourceTests: PageboyTests {
    
    /// Test loading view controllers from the data source.
    func testPageboyViewControllerValidSetUp() {
        self.dataSource.numberOfPages = 1
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssert(self.pageboyViewController.viewControllers?.count == 1,
                  "View Controllers were not successfully loaded from the data source.")
    }
    
    /// Test loading an empty view controller array from the data source.
    func testPageboyViewControllerEmptySetUp() {
        self.dataSource.numberOfPages = 0
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssert(self.pageboyViewController.viewControllers?.count == 0,
                  "Empty view controller array not successfully loaded from the data source.")
    }
    
    /// Test loading a nil array from the data source.
    func testPageboyViewControllerNilSetUp() {
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssert(self.pageboyViewController.viewControllers == nil,
                  "View Controller array is not nil when data source returns nil.")
    }
    
    /// Test using the default .first PageIndex when nil returned
    /// in defaultPageIndex(forPageboyViewController:).
    func testPageboyViewControllerDefaultPageIndexDefault() {
        self.dataSource.numberOfPages = 3
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssert(self.pageboyViewController.currentIndex == 0,
                  "Default Page index is not using correct .first PageIndex when no value is returned.")
    }
    
    /// Test using a custom PageIndex when returned
    /// in defaultPageIndex(forPageboyViewController:).
    func testPageboyViewControllerDefaultPageIndexCustom() {
        self.dataSource.numberOfPages = 3
        self.dataSource.defaultIndex = .atIndex(index: 1)
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssert(self.pageboyViewController.currentIndex == 1,
                  "Default page index is not using correct index when specified.")
    }
    
    /// Test using a custom out of range PageIndex when returned
    /// in defaultPageIndex(forPageboyViewController:).
    func testPageboyViewControllerDefaultPageIndexOutOfRange() {
        self.dataSource.numberOfPages = 3
        self.dataSource.defaultIndex = .atIndex(index: 4)
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssert(self.pageboyViewController.currentIndex == nil,
                  "Default page index is not correctly erroring when out of range index specified.")
    }
    
    /// Test using an invalid .next PageIndex when returned
    /// in defaultPageIndex(forPageboyViewController:).
    func testPageboyViewControllerDefaultPageIndexInvalid() {
        self.dataSource.numberOfPages = 3
        self.dataSource.defaultIndex = .next
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssert(self.pageboyViewController.currentIndex == 0,
                  "Default page index is not correctly handling an invalid index specified.")
    }
    
    /// Test using .first PageIndex when returned
    /// in defaultPageIndex(forPageboyViewController:).
    func testPageboyViewControllerDefaultPageIndexFirst() {
        self.dataSource.numberOfPages = 3
        self.dataSource.defaultIndex = .first
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssert(self.pageboyViewController.currentIndex == 0,
                  "Default Page index is not using correct .first PageIndex when specified.")
    }
    
    /// Test using .last PageIndex when returned
    /// in defaultPageIndex(forPageboyViewController:).
    func testPageboyViewControllerDefaultPageIndexLast() {
        self.dataSource.numberOfPages = 3
        self.dataSource.defaultIndex = .last
        self.pageboyViewController.dataSource = self.dataSource
        
        XCTAssert(self.pageboyViewController.currentIndex == 2,
                  "Default Page index is not using correct .last PageIndex when specified.")
    }
    
    /// Test whether reloadPages fully reloads 
    /// PageboyViewController.
    func testPageboyViewControllerReloadBehavior() {
        self.dataSource.numberOfPages = 5
        self.pageboyViewController.dataSource = self.dataSource
        let initialPageCount = self.pageboyViewController.viewControllers?.count
        
        self.dataSource.numberOfPages = 3
        self.pageboyViewController.reloadPages()
        let reloadPageCount = self.pageboyViewController.viewControllers?.count
        
        XCTAssert(initialPageCount == 5 && reloadPageCount == 3,
                  "reloadPages is not correctly reloading view controllers.")
    }
}
