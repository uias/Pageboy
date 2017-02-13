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

public protocol PageboyViewControllerDelegate {
 
    
    /// The page view controller did scroll to an offset between pages.
    ///
    /// - Parameters:
    ///   - pageboyViewController: The Pageboy view controller.
    ///   - pageOffset: The current offset.
    ///   - direction: The direction of the scroll.
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToOffset pageOffset: CGPoint,
                               direction: PageboyViewController.NavigationDirection)
    
    /// The page view controller did complete scroll to a new page.
    ///
    /// - Parameters:
    ///   - pageboyViewController: The Pageboy view controller.
    ///   - pageIndex: The new page index.
    ///   - direction: The direction of the scroll.
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageWithIndex pageIndex: Int,
                               direction: PageboyViewController.NavigationDirection)
}

open class PageboyViewController: UIViewController {
    
    //
    // MARK: Types
    //
    
    public enum NavigationDirection {
        case neutral
        case progressive
        case regressive
    }
    
    public typealias PageTransitionCompletion = (_ newViewController: UIViewController, _ animated: Bool, _ finished: Bool) -> Void
    
    //
    // MARK: Properties
    //
    
    internal var pageViewController: UIPageViewController!
    internal var viewControllers: [UIViewController]?
    
    internal var currentPageIndex: Int = 0 {
        willSet {
            let direction: NavigationDirection = newValue == currentPageIndex ? .neutral :
                newValue > currentPageIndex ? .progressive : .regressive
            self.delegate?.pageboyViewController(self,
                                                 didScrollToPageWithIndex: newValue,
                                                 direction: direction)
        }
    }
    internal var previousPageOffset: CGFloat?
    
    private var _dataSource: PageboyViewControllerDataSource?
    
    //
    // MARK: Public Properties
    //
    
    /// The orientation that the page view controller transitions on.
    public var navigationOrientation : UIPageViewControllerNavigationOrientation = .horizontal {
        didSet {
            guard self.pageViewController != nil else {
                return
            }
            
            self.setUpPageViewController(reloadViewControllers: false)
        }
    }
    
    /// The object that is the data source for the page view controller. (Defaults to self)
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
    
    /// The object that is the delegate for the page view controller.
    public var delegate: PageboyViewControllerDelegate?
    
    //
    // MARK: Lifecycle
    //
    
    open override func loadView() {
        super.loadView()
        
        self.setUpPageViewController()
    }
    
    //
    // MARK: Set Up
    //
    
    private func setUpPageViewController(reloadViewControllers: Bool = true) {
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
        
        self.reloadPages(reloadViewControllers: reloadViewControllers)
    }
    
    //
    // MARK: Transitioning
    //
    
    public func transitionToPage(atIndex index: Int,
                                 animated: Bool,
                                 completion: PageTransitionCompletion? = nil) {
        if index != self.currentPageIndex {
            
            // transition to page
            
        } else {
            guard let viewController = self.viewControllers?[index] else {
                return
            }
            completion?(viewController, animated, false)
        }
    }
}




