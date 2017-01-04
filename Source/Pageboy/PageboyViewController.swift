//
//  PageboyViewController.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 04/01/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

open class PageboyViewController: UIViewController {
    
    // MARK: Properties
    
    private var pageViewController: UIPageViewController?
    
    
    public var navigationOrientation : UIPageViewControllerNavigationOrientation = .horizontal {
        didSet {
            self.setUpPageViewController()
        }
    }
    
    // MARK: Lifecycle
    
    override open func loadView() {
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
    }
}

extension PageboyViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
}
