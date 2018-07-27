//
//  PageViewController.swift
//  PageboyTestsApp
//
//  Created by Merrick Sapsford on 27/07/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit
import Pageboy

class PageViewController: PageboyViewController, PageboyViewControllerDataSource {
    
    let viewControllers: [UIViewController] = {
        var viewControllers = [UIViewController]()
        for index in 0 ..< 5 {
            let viewController = UIViewController()
            viewController.view.backgroundColor = (index % 2) == 0 ? .red : .blue
            viewControllers.append(viewController)
        }
        return viewControllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> Page? {
        return nil
    }
}
