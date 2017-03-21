//
//  TestPageboyDataSource.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import Foundation
import Pageboy

class TestPageboyDataSource: Any, PageboyViewControllerDataSource {
    
    var numberOfPages: Int?
    var defaultIndex: PageboyViewController.PageIndex?
    private(set) var viewControllers = [UIViewController]()
    
    func viewControllers(forPageboyViewController pageboyViewController: PageboyViewController) -> [UIViewController]? {
        guard let numberOfPages = self.numberOfPages else {
            return nil
        }
        
        viewControllers.removeAll()
        for index in 0..<numberOfPages {
            let viewController = TestPageChildViewController()
            viewController.index = index
            viewControllers.append(viewController)
        }
        
        return viewControllers
    }
    
    func defaultPageIndex(forPageboyViewController pageboyViewController: PageboyViewController) -> PageboyViewController.PageIndex? {
        return defaultIndex
    }
}
