//
//  PageboyViewController.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 04/01/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

public protocol PageboyViewControllerDataSource: class {
    
    
    /// The view controllers to display in the Pageboy view controller.
    ///
    /// - Parameter pageboyViewController: The Pageboy view controller
    /// - Returns: Array of view controllers
    func viewControllers(forPageboyViewController pageboyViewController: PageboyViewController) -> [UIViewController]?
    
    /// The default page index to display in the Pageboy view controller.
    ///
    /// - Parameter pageboyViewController: The Pageboy view controller
    /// - Returns: Default page index
    func defaultPageIndex(forPageboyViewController pageboyViewController: PageboyViewController) -> Int
}

open class PageboyViewController: UIViewController {
    
    // MARK: Properties
    
    internal var pageViewController: UIPageViewController!
    internal var viewControllers: [UIViewController]?
    
    internal var currentPageIndex: Int = 0
    internal var previousPageOffset: CGFloat?
    
    // MARK: Public Properties

    public var navigationOrientation : UIPageViewControllerNavigationOrientation = .horizontal {
        didSet {
            self.setUpPageViewController()
        }
    }
    
    private var _dataSource: PageboyViewControllerDataSource?
    public var dataSource: PageboyViewControllerDataSource? {
        get {
            if let dataSource = _dataSource {
                return dataSource
            }
            return self
        }
        set {
            if _dataSource !== newValue {
                _dataSource = newValue
                self.reloadPages()
            }
        }
    }
    
    // MARK: Lifecycle
    
    open override func loadView() {
        super.loadView()
        
        self.setUpPageViewController()
    }
    
    // MARK: Set Up
    
    private func setUpPageViewController() {
        if self.pageViewController != nil { // destroy existing page VC
            self.pageViewController?.view.removeFromSuperview()
            self.pageViewController?.removeFromParentViewController()
            self.pageViewController = nil
        }
        
        let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: self.navigationOrientation,
                                                      options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        self.pageViewController = pageViewController
        
        self.view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
        
        pageViewController.scrollView?.delegate = self
        
        self.reloadPages()
    }
}




