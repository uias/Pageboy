//
//  PageViewController.swift
//  Example
//
//  Created by Merrick Sapsford on 04/10/2020.
//  Copyright © 2020 UI At Six. All rights reserved.
//

import UIKit
import Pageboy

class PageViewController: PageboyViewController {

    // MARK: Properties
    
    /// View controllers that will be displayed in page view controller.
    private lazy var viewControllers: [UIViewController] = {
        (1 ... 10).map({ ChildViewController(page: $0) })
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
