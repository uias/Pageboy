//
//  TestPageboyDataSource.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import Foundation
import Pageboy

class TestPageboyDataSource: PageboyViewControllerDataSource {
    
    var numberOfPages: Int? {
        didSet {
            guard let numberOfPages = numberOfPages else {
                self.viewControllers = nil
                return
            }
            self.viewControllers = generateViewControllers(count: numberOfPages)
        }
    }
    var defaultIndex: PageboyViewController.Page?
    var viewControllers: [UIViewController]?
        
    // MARK: PageboyViewControllerDataSource
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers?.count ?? 0
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers?[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return defaultIndex
    }
    
    // MARK: Utility
    
    func generateViewControllers(count: Int) -> [UIViewController] {
        var viewControllers = [UIViewController]()
        
        for index in 0 ..< count {
            
            let viewController = TestPageChildViewController()
            viewController.index = index
            viewControllers.append(viewController)
        }
        
        return viewControllers
    }
}
