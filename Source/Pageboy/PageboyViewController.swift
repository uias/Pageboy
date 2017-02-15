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
 
    /// The page view controller will begin scrolling to a new page.
    ///
    /// - Parameters:
    ///   - pageboyViewController: The Pageboy view controller.
    ///   - pageIndex: The new page index.
    ///   - direction: The direction of the scroll.
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               willScrollToPageAtIndex pageIndex: Int,
                               direction: PageboyViewController.NavigationDirection)
    
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
    
    /// The direction that the page view controller travelled.
    ///
    /// - neutral: No movement.
    /// - forward: Moved in a positive direction.
    /// - reverse: Moved in a negative direction.
    public enum NavigationDirection {
        case neutral
        case forward
        case reverse
    }
    
    /// The index of a page in the page view controller.
    ///
    /// - next: The next page if available.
    /// - previous: The previous page if available.
    /// - atIndex: A custom specified page index.
    public enum PageIndex {
        case next
        case previous
        case atIndex(index: Int)
    }
    
    public typealias PageTransitionCompletion = (_ newViewController: UIViewController, _ animated: Bool, _ finished: Bool) -> Void
    
    //
    // MARK: Variables
    //
    
    internal var pageViewController: UIPageViewController!
    internal var viewControllers: [UIViewController]?
    
    internal var currentPageIndex: Int = 0 {
        willSet {
            let direction = NavigationDirection.forOffset(CGFloat(newValue),
                                                          previousOffset: CGFloat(currentPageIndex))
            self.delegate?.pageboyViewController(self,
                                                 didScrollToPageWithIndex: newValue,
                                                 direction: direction)
        }
    }
    internal var previousPagePosition: CGFloat?
    
    private var _dataSource: PageboyViewControllerDataSource?
    
    //
    // MARK: Properties
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
    
    /// Whether the page view controller should infinitely scroll at the end of page ranges.
    ///
    /// Default is FALSE.
    public var isInfiniteScrollEnabled: Bool = false
    
    /// Whether scroll is enabled on the page view controller.
    ///
    /// Default is TRUE.
    public var isScrollEnabled: Bool = true {
        didSet {
            self.pageViewController.scrollView?.isScrollEnabled = isScrollEnabled
        }
    }
    
    /// Whether the page view controller is currently being dragged.
    public var isDragging: Bool {
        get {
            return self.pageViewController.scrollView?.isDragging ?? false
        }
    }
    
    /// Whether user interaction is enabled on the page view controller.
    ///
    /// Default is TRUE
    public var isUserInteractionEnabled: Bool = true {
        didSet {
            self.pageViewController.scrollView?.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }
    
    /// Whether the page view controller is currently transitioning between pages.
    private(set) var isTransitioning = false {
        didSet {
            self.isUserInteractionEnabled = !self.isTransitioning
        }
    }
    
    //
    // MARK: Lifecycle
    //
    
    open override func loadView() {
        super.loadView()
        
        self.setUpPageViewController()
    }
    
    //
    // MARK: Page management
    //
    
    /// Reload the view controllers in the page view controller. 
    /// This reloads the dataSource entirely, calling viewControllers(forPageboyViewController:)
    /// and defaultPageIndex(forPageboyViewController:).
    public func reloadPages() {
        self.reloadPages(reloadViewControllers: true)
    }
    
    //
    // MARK: Transitioning
    //
    
    /// Transition the page view controller to a new page.
    ///
    /// - parameter index:      The index of the new page.
    /// - parameter animated:   Whether to animate the transition.
    /// - parameter completion: The completion closure.
    public func transitionToPage(_ index: PageIndex,
                                 animated: Bool,
                                 completion: PageTransitionCompletion? = nil) {
        guard self.isTransitioning == false else { return }
        
        let rawIndex = self.indexValue(forPageIndex: index)
        if rawIndex != self.currentPageIndex {
            guard rawIndex >= 0 && rawIndex < self.viewControllers?.count ?? 0 else { return }
            guard let viewController = self.viewControllers?[rawIndex] else { return }
            
            let direction = NavigationDirection.forPage(rawIndex, previousPage: self.currentPageIndex)
            self.isTransitioning = true
            self.pageViewController.setViewControllers([viewController],
                                                       direction: direction.pageViewControllerNavDirection,
                                                       animated: animated,
                                                       completion:
                { (finished) in
                    if finished {
                        self.currentPageIndex = rawIndex
                    }
                    completion?(viewController, animated, finished)
                    self.isTransitioning = false
            })
            
        } else {
            guard let viewController = self.viewControllers?[rawIndex] else {
                return
            }
            completion?(viewController, animated, false)
        }
    }
    
}

// MARK: - Page view controller Set up & Utilities
internal extension PageboyViewController {
    
    //
    // MARK: Set Up
    //
    
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
        
        self.view.addSubview(pageViewController.view)
        self.view.sendSubview(toBack: pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
        
        pageViewController.scrollView?.delegate = self
        
        self.reloadPages(reloadViewControllers: reloadViewControllers)
    }

    //
    // MARK: Utilities
    //
    
    internal func indexValue(forPageIndex pageIndex: PageIndex) -> Int {
        switch pageIndex {
            
        case .next:
            return self.currentPageIndex + 1
            
        case .previous:
            return self.currentPageIndex - 1
            
        case .atIndex(let index):
            return index
        }
    }
}
