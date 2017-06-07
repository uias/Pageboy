//
//  PageboyControllerManagement.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 13/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

// MARK: - Paging Set Up and Configuration
internal extension PageboyViewController {
    
    // MARK: Set Up
    
    /// Set up inner UIPageViewController ready for displaying pages.
    ///
    /// - Parameter reloadViewControllers: Reload the view controllers data source for the PageboyViewController.
    internal func setUpPageViewController(reloadViewControllers: Bool = true) {
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
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.view.pinToSuperviewEdges()
        self.view.sendSubview(toBack: pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
        
        pageViewController.scrollView?.delegate = self
        
        self.pageViewController.view.backgroundColor = .clear
        
        self.reloadPages(reloadViewControllers: reloadViewControllers)
    }
    
    /// Reload the pages in the PageboyViewController
    ///
    /// - Parameter reloadViewControllers: Reload the view controller data source.
    internal func reloadPages(reloadViewControllers: Bool) {
        
        if reloadViewControllers || self.viewControllers == nil {
            self.viewControllers = self.dataSource?.viewControllers(forPageboyViewController: self)
        }
        let defaultIndex = self.dataSource?.defaultPageIndex(forPageboyViewController: self) ?? .first
        let defaultIndexValue = self.indexValue(for: defaultIndex)
        
        guard defaultIndexValue < self.viewControllers?.count ?? 0,
            let viewController = self.viewControllers?[defaultIndexValue] else {
                return
        }
        
        self.currentIndex = defaultIndexValue
        self.pageViewController.setViewControllers([viewController],
                                                   direction: .forward,
                                                   animated: false,
                                                   completion: nil)
        
        guard let viewControllers = self.viewControllers else { return }
        self.delegate?.pageboyViewController(self,
                                             didReload: viewControllers,
                                             currentIndex: defaultIndex)
    }
    
    // MARK: Utilities
    
    /// Convert a PageIndex to a raw index integer.
    ///
    /// - Parameter pageIndex: The page index to translate.
    /// - Returns: The raw index integer.
    internal func indexValue(for pageIndex: PageIndex) -> Int {
        switch pageIndex {
            
        case .next:
            guard let currentIndex = self.currentIndex else {
                return 0
            }
            var proposedIndex = currentIndex + 1
            if self.isInfiniteScrollEnabled && proposedIndex == self.viewControllers?.count { // scroll back to first index
                proposedIndex = 0
            }
            return proposedIndex
            
        case .previous:
            guard let currentIndex = self.currentIndex else {
                return 0
            }
            var proposedIndex = currentIndex - 1
            if self.isInfiniteScrollEnabled && proposedIndex < 0 { // scroll to last index
                proposedIndex = (self.viewControllers?.count ?? 1) - 1
            }
            return proposedIndex
            
        case .first:
            return 0
            
        case .last:
            return (self.viewControllers?.count ?? 1) - 1
            
        case .atIndex(let index):
            return index
            
        case .at(let index):
            return index
        }
    }
}

// MARK: - UIPageViewControllerDataSource, PageboyViewControllerDataSource
extension PageboyViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllers = self.viewControllers else {
            return nil
        }
        
        if let index = viewControllers.index(of: viewController) {
            if index != 0 {
                return viewControllers[index - 1]
            } else if self.isInfiniteScrollEnabled {
                return viewControllers[viewControllers.count - 1]
            }
        }
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllers = self.viewControllers else {
            return nil
        }
        
        if let index = viewControllers.index(of: viewController) {
            if index != viewControllers.count - 1 {
                return viewControllers[index + 1]
            } else if self.isInfiniteScrollEnabled {
                return viewControllers[0]
            }
        }
        return nil
    }
}
