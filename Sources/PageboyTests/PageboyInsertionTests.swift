//
//  PageboyInsertionTests.swift
//  PageboyTests
//
//  Created by Merrick Sapsford on 13/11/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import XCTest
@testable import Pageboy

class PageboyInsertionTests: PageboyTests {

    func testInsertPage() {
        let initialCount = 4
        dataSource.numberOfPages = initialCount
        pageboyViewController.dataSource = dataSource
        
        // Insert
        let index = 0
        let viewController = dataSource.generateViewControllers(count: 1)[index]
        dataSource.viewControllers?.insert(viewController, at: index)
        pageboyViewController.insertPage(at: index, then: .doNothing)
        
        XCTAssert(pageboyViewController.pageCount == initialCount + 1)
    }
    
    func testDeletePage() {
        let initialCount = 5
        dataSource.numberOfPages = initialCount
        pageboyViewController.dataSource = dataSource
        
        let index = 2
        dataSource.viewControllers?.remove(at: index)
        pageboyViewController.deletePage(at: index, then: .doNothing)
        
        XCTAssert(pageboyViewController.pageCount == initialCount - 1)
    }
}
