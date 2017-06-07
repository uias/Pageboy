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
    func defaultPageIndex(forPageboyViewController pageboyViewController: PageboyViewController) -> PageboyViewController.PageIndex?
}

public protocol PageboyViewControllerDelegate: class {
 
    /// The page view controller will begin scrolling to a new page.
    ///
    /// - Parameters:
    ///   - pageboyViewController: The Pageboy view controller.
    ///   - index: The new page index.
    ///   - direction: The direction of the scroll.
    ///   - animation: Whether the scroll will be animated.
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               willScrollToPageAtIndex index: Int,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool)
    
    /// The page view controller did scroll to an offset between pages.
    ///
    /// - Parameters:
    ///   - pageboyViewController: The Pageboy view controller.
    ///   - position: The current relative page position.
    ///   - direction: The direction of the scroll.
    ///   - animated: Whether the scroll is being animated.
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPosition position: CGPoint,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool)
    
    /// The page view controller did complete scroll to a new page.
    ///
    /// - Parameters:
    ///   - pageboyViewController: The Pageboy view controller.
    ///   - index: The new page index.
    ///   - direction: The direction of the scroll.
    ///   - animation: Whether the scroll was animated.
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageAtIndex index: Int,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool)
    
    /// The page view controller did reload its view controllers.
    ///
    /// - Parameters:
    ///   - pageboyViewController: The Pageboy view controller.
    ///   - viewControllers: The new view controllers.
    ///   - currentIndex: The current page index.
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didReload viewControllers: [UIViewController],
                               currentIndex: PageboyViewController.PageIndex)
}

/// A simple, highly informative page view controller.
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
    /// - first: The first page.
    /// - last: The last page.
    /// - at: A custom specified page index.
    public enum PageIndex {
        case next
        case previous
        case first
        case last
        case at(index: Int)
        
        @available(*, deprecated: 1.0.3, message: "Use at(index: Int)")
        case atIndex(index: Int)
    }
    
    
    /// Completion of a page scroll.
    public typealias PageScrollCompletion = (_ newViewController: UIViewController, _ animated: Bool, _ finished: Bool) -> Void
    
    //
    // MARK: Variables
    //
    
    internal var pageViewController: UIPageViewController!
    internal var previousPagePosition: CGFloat?
    internal var expectedTransitionIndex: Int?

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
    
    /// Preferred status bar style of the current view controller.
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if let currentViewController = self.currentViewController {
            return currentViewController.preferredStatusBarStyle
        }
        return super.preferredStatusBarStyle
    }
    
    /// Preferred status bar hidden of the current view controller.
    open override var prefersStatusBarHidden: Bool {
        if let currentViewController = self.currentViewController {
            return currentViewController.prefersStatusBarHidden
        }
        return super.prefersStatusBarHidden
    }
    
    /// The object that is the data source for the page view controller. (Defaults to self)
    public weak var dataSource: PageboyViewControllerDataSource? {
        didSet {
            self.reloadPages()
        }
    }
    
    /// The object that is the delegate for the page view controller.
    public weak var delegate: PageboyViewControllerDelegate?
    
    /// Whether the page view controller is currently being touched.
    public var isTracking: Bool {
        return self.pageViewController.scrollView?.isTracking ?? false
    }
    /// Whether the page view controller is currently being dragged.
    public var isDragging: Bool {
            return self.pageViewController.scrollView?.isDragging ?? false
    }
    // default is YES. if NO, we immediately call -touchesShouldBegin:withEvent:inContentView:. this has no effect on presses
    public var delaysContentTouches: Bool {
        set {
            self.pageViewController.scrollView?.delaysContentTouches = newValue
        } get {
            return self.pageViewController.scrollView?.delaysContentTouches ?? false
        }
    }
    /// default YES. if YES, bounces past edge of content and back again.
    public var bounces: Bool = true
    
    /// Whether user interaction is enabled on the page view controller.
    ///
    /// Default is TRUE
    public var isUserInteractionEnabled: Bool = true {
        didSet {
            self.pageViewController.scrollView?.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }
    /// Whether scroll is enabled on the page view controller.
    ///
    /// Default is TRUE.
    public var isScrollEnabled: Bool = true {
        didSet {
            self.pageViewController.scrollView?.isScrollEnabled = isScrollEnabled
        }
    }
    /// Whether the page view controller should infinitely scroll at the end of page ranges.
    ///
    /// Default is FALSE.
    public var isInfiniteScrollEnabled: Bool = false {
        didSet {
            self.reloadCurrentPageSoftly()
        }
    }
    
    /// Whether the page view controller is currently animating a scroll between pages.
    private(set) var isScrollingAnimated = false {
        didSet {
            self.isUserInteractionEnabled = !self.isScrollingAnimated
        }
    }
    
    /// The transition to use when animating scrolls between pages.
    public var transition = Transition.defaultTransition
    /// The display link for transitioning.
    internal var transitionDisplayLink: CADisplayLink?
    /// The active transition operation.
    internal var activeTransition: TransitionOperation?
    
    /// The view controllers that are displayed in the page view controller.
    public internal(set) var viewControllers: [UIViewController]?
    
    /// The page index that the page view controller is currently at.
    public internal(set) var currentIndex: Int? {
        didSet {
            guard let currentIndex = self.currentIndex else { return }

            UIView.animate(withDuration: 0.3) { 
                self.setNeedsStatusBarAppearanceUpdate()
            }
            
            // ensure position keeps in sync
            self.currentPosition = CGPoint(x: self.navigationOrientation == .horizontal ? CGFloat(currentIndex) : 0.0,
                                           y: self.navigationOrientation == .vertical ? CGFloat(currentIndex) : 0.0)
            let direction = NavigationDirection.forPosition(CGFloat(currentIndex),
                                                            previous: CGFloat(oldValue ?? currentIndex))
            self.delegate?.pageboyViewController(self,
                                                 didScrollToPageAtIndex: currentIndex,
                                                 direction: direction,
                                                 animated: self.isScrollingAnimated)

        }
    }
    
    /// The relative page position that the page view controller is currently at.
    public internal(set) var currentPosition: CGPoint?
    
    /// The view controller that the page view controller is currently at.
    public var currentViewController: UIViewController? {
        get {
            guard let currentIndex = self.currentIndex,
                self.viewControllers?.count ?? 0 > currentIndex else {
                return nil
            }
            return self.viewControllers?[currentIndex]
        }
    }
    
    /// Auto Scroller for automatic time-based page transitions.
    public let autoScroller = PageboyAutoScroller()
    
    //
    // MARK: Lifecycle
    //
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.autoScroller.handler = self
        self.setUpTransitioning()
        self.setUpPageViewController()
    }
    
    open override func viewWillTransition(to size: CGSize,
                                          with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // ignore scroll updates during orientation change
        self.pageViewController.scrollView?.delegate = nil
        coordinator.animate(alongsideTransition: nil) { (context) in
            self.pageViewController.scrollView?.delegate = self
        }
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
    
    /// Reload the currently active page into the page view controller if possible. 
    /// Does not reload from dataSource.
    private func reloadCurrentPageSoftly() {
        guard let currentIndex = self.currentIndex else { return }
        guard let currentViewController = self.viewControllers?[currentIndex] else { return }
        
        self.pageViewController.setViewControllers([currentViewController], direction: .forward, animated: false, completion: nil)
    }
    
    //
    // MARK: Scrolling
    //
    
    /// Scroll the page view controller to a new page.
    ///
    /// - parameter index:      The index of the new page.
    /// - parameter animated:   Whether to animate the transition.
    /// - parameter completion: The completion closure.
    public func scrollToPage(_ pageIndex: PageIndex,
                             animated: Bool,
                             completion: PageScrollCompletion? = nil) {
        
        // guard against any current transition operation
        guard self.isScrollingAnimated == false else { return }
        guard self.isTracking == false else { return }
        
        let rawIndex = self.indexValue(for: pageIndex  )
        if rawIndex != self.currentIndex {
            
            // guard against invalid page indexing
            guard rawIndex >= 0 && rawIndex < self.viewControllers?.count ?? 0 else { return }
            guard let viewController = self.viewControllers?[rawIndex] else { return }
            
            var direction = NavigationDirection.forPage(rawIndex, previousPage: self.currentIndex ?? rawIndex)
            
            if isInfiniteScrollEnabled {
                switch pageIndex {
                case .next:
                    direction = .forward
                case .previous:
                    direction = .reverse
                default: break
                }
            }
            
            self.pageViewController(self.pageViewController,
                                    willTransitionTo: [viewController],
                                    animated: animated)
            
            self.isScrollingAnimated = animated
            
            let transitionCompletion: TransitionOperation.Completion = { (finished) in
                if finished {
                    let isVertical = self.navigationOrientation == .vertical
                    self.currentPosition = CGPoint(x: isVertical ? 0.0 : CGFloat(rawIndex),
                                                   y: isVertical ? CGFloat(rawIndex) : 0.0)
                    self.currentIndex = rawIndex
                    
                    // if not animated call position delegate update manually
                    if !animated {
                        self.delegate?.pageboyViewController(self,
                                                             didScrollToPosition: self.currentPosition!,
                                                             direction: direction,
                                                             animated: animated)
                    }
                }
                self.autoScroller.didFinishScrollIfEnabled()
                completion?(viewController, animated, finished)
                self.isScrollingAnimated = false
            }
            
            self.performTransition(from: currentIndex ?? 0,
                                   to: rawIndex,
                                   with: direction,
                                   animated: animated,
                                   completion: transitionCompletion)
            self.pageViewController.setViewControllers([viewController],
                                                       direction: direction.pageViewControllerNavDirection,
                                                       animated: false,
                                                       completion:
                { (finished) in
                    guard animated == false else { return }
                    transitionCompletion(finished)
            })
            
        } else {
            guard let viewController = self.viewControllers?[rawIndex] else {
                return
            }
            self.autoScroller.didFinishScrollIfEnabled()
            completion?(viewController, animated, false)
        }
    }
    
}
