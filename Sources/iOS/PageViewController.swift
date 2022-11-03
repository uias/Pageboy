//
//  PageViewController.swift
//  Example
//
//  Created by Merrick Sapsford on 04/10/2020.
//  Copyright © 2020 UI At Six. All rights reserved.
//

import UIKit
import Pageboy

class PageViewController: PageboyViewController, PageboyViewControllerDataSource {

    // MARK: Properties
    
    /// View controllers that will be displayed in page view controller.
    private lazy var viewControllers: [UIViewController] = {
        (1 ... 10).map({ ChildViewController(page: $0) })
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set PageboyViewControllerDataSource dataSource to configure page view controller.
        dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(scrollToNextPage(_:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(scrollToPreviousPage(_:)))
    }

    // MARK: PageboyViewControllerDataSource
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        viewControllers.count // How many view controllers to display in the page view controller.
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index] // View controller to display at a specific index for the page view controller.
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        nil // Default page to display in the page view controller (nil equals default/first index).
    }
    
    // MARK: Actions
    
    @objc func scrollToNextPage(_ sender: UIBarButtonItem) {
        scrollToPage(.next, animated: true)
    }
    
    @objc func scrollToPreviousPage(_ sender: UIBarButtonItem) {
        scrollToPage(.previous, animated: true)
    }
}
