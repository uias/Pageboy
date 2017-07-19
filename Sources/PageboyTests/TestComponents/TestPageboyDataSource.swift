//
//  TestPageboyDataSource.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
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
    private(set) var viewControllers: [UIViewController]?
    
    private(set) var reloadCount = 0
    
    // MARK: PageboyViewControllerDataSource
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return numberOfPages ?? 0
    }
    
    func viewController(at index: PageboyViewController.PageIndex,
                        in pageboyViewController: PageboyViewController) -> UIViewController? {
        return self.viewControllers?[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return defaultIndex
    }
    
    // MARK: Utility
    
    private func generateViewControllers(count: Int) -> [UIViewController] {
        var viewControllers = [UIViewController]()
        
        for index in 0 ..< count {
            
            let viewController = TestPageChildViewController()
            viewController.index = index
            viewControllers.append(viewController)
        }
        
        return viewControllers
    }
}
