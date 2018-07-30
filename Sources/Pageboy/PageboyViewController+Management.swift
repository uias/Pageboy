//
//  PageboyControllerManagement.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 13/02/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

// MARK: - VC Reloading
public extension PageboyViewController {
    
    /// Reload the view controllers in the page view controller.
    /// This reloads the dataSource entirely, calling viewControllers(forPageboyViewController:)
    /// and defaultPageIndex(forPageboyViewController:).
    public func reloadPages() {
        self.reloadPages(reloadViewControllers: true)
    }
    
    /// Reload the pages in the PageboyViewController
    ///
    /// - Parameter reloadViewControllers: Reload the view controller data source.
    internal func reloadPages(reloadViewControllers: Bool) {
        
        if reloadViewControllers {
            viewControllerMap.clear()
        }
        
        let viewControllerCount = dataSource?.numberOfViewControllers(in: self) ?? 0
        self.viewControllerCount = viewControllerCount
        
        let defaultPage = self.dataSource?.defaultPage(for: self) ?? .first
        let defaultIndex = defaultPage.indexValue(in: self)
        
        guard defaultIndex < viewControllerCount,
            let viewController = viewController(at: defaultIndex) else {
                return
        }
        
        updateViewControllers(to: [viewController], animated: false, async: false, force: false) { _ in
            self.currentIndex = defaultIndex
            self.delegate?.pageboyViewController(self,
                                                 didReloadWith: viewController,
                                                 currentPageIndex: defaultIndex)
        }
    }
    
    /// Reload the currently active page into the page view controller if possible.
    internal func reloadCurrentPageSoftly() {
        guard let currentIndex = self.currentIndex else {
            return
        }
        guard let currentViewController = viewController(at: currentIndex) else {
            return
        }
        
        updateViewControllers(to: [currentViewController],
                              animated: false,
                              async: false,
                              force: false,
                              completion: nil)
    }
}

// MARK: - VC Updating
internal extension PageboyViewController {
    
    func updateViewControllers(to viewControllers: [UIViewController],
                               from fromIndex: PageIndex = 0,
                               to toIndex: PageIndex = 0,
                               direction: NavigationDirection = .forward,
                               animated: Bool,
                               async: Bool,
                               force: Bool,
                               completion: TransitionOperation.Completion?) {
        guard let pageViewController = self.pageViewController else {
            return
        }
        if isUpdatingViewControllers && !force {
            return
        }
        
        
        targetIndex = toIndex
        isUpdatingViewControllers = true
        
        let isUsingCustomTransition = transition != nil
        if isUsingCustomTransition {
            performTransition(from: fromIndex,
                              to: toIndex,
                              with: direction,
                              animated: animated,
                              completion: completion ?? { _ in })
        }
        
        // if not using a custom transition then animate using UIPageViewController mechanism
        let animateUpdate = animated ? !isUsingCustomTransition : false
        let updateBlock = {
            pageViewController.setViewControllers(viewControllers,
                                                  direction: direction.layoutNormalized(isRtL: self.view.layoutIsRightToLeft).rawValue,
                                                  animated: animateUpdate,
                                                  completion:
                { (finished) in
                    self.isUpdatingViewControllers = false
                    
                    if !animated || !isUsingCustomTransition {
                        completion?(finished)
                    }
            })
        }
        
        // Attempt to fix issue where fast scrolling causes crash.
        // See https://github.com/uias/Pageboy/issues/140
        if async {
            DispatchQueue.main.async {
                updateBlock()
            }
        } else {
            updateBlock()
        }
    }
}

// MARK: - Data Source interaction
internal extension PageboyViewController {
    
    /// Load view controller from the data source.
    ///
    /// - Parameter index: Index of the view controller to load.
    /// - Returns: View controller if it exists.
    func viewController(at index: PageIndex) -> UIViewController? {
        let viewController = dataSource?.viewController(for: self, at: index)
        if let viewController = viewController {
            let wrapper = WeakWrapper<UIViewController>(with: viewController)
            viewControllerMap.set(object: wrapper, for: index)
            
            childScrollObserver.register(viewController: viewController, for: index)
        }
        return viewController
    }
}

// MARK: - UIPageViewController Set Up
internal extension PageboyViewController {
    
    // MARK: Set Up
    
    /// Set up inner UIPageViewController ready for displaying pages.
    ///
    /// - Parameter reloadViewControllers: Reload the view controllers data source for the PageboyViewController.
    internal func setUpPageViewController(reloadViewControllers: Bool = true) {
        var existingZIndex: Int?
        if let pageViewController = self.pageViewController { // destroy existing page VC
            existingZIndex = self.view.subviews.index(of: pageViewController.view)
            self.pageViewController?.view.removeFromSuperview()
            self.pageViewController?.removeFromParent()
            self.pageViewController = nil
        }
        
        let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: self.navigationOrientation,
                                                      options: convertToOptionalUIPageViewControllerOptionsKeyDictionary(self.pageViewControllerOptions))
        pageViewController.delegate = self
        pageViewController.dataSource = self
        self.pageViewController = pageViewController
        
        addChild(pageViewController)
        if let existingZIndex = existingZIndex {
            view.insertSubview(pageViewController.view, at: existingZIndex)
        } else {
            view.addSubview(pageViewController.view)
            view.sendSubviewToBack(pageViewController.view)
        }
        pageViewController.view.pinToSuperviewEdges()
        pageViewController.didMove(toParent: self)
      
        // Add hidden scroll view that will be used to interact with navigation bar large titles.
        let invisibleScrollView = ParentMatchedScrollView.matching(parent: self.view)
        view.addSubview(invisibleScrollView)
        view.sendSubviewToBack(invisibleScrollView)
        self.invisibleScrollView = invisibleScrollView
        
        pageViewController.scrollView?.delegate = self
        pageViewController.view.backgroundColor = .clear
        pageViewController.scrollView?.delaysContentTouches = delaysContentTouches
        pageViewController.scrollView?.isScrollEnabled = isScrollEnabled
        pageViewController.scrollView?.isUserInteractionEnabled = isUserInteractionEnabled
        
        self.reloadPages(reloadViewControllers: reloadViewControllers)
    }
    
    /// Re-initialize the internal UIPageViewController instance without reloading data source if it currently exists.
    internal func reconfigurePageViewController() {
        guard self.pageViewController != nil else {
            return
        }
        self.setUpPageViewController(reloadViewControllers: false)
    }
    
    /// The options to be passed to a UIPageViewController instance.
    internal var pageViewControllerOptions: [String: Any]? {
        var options = [String: Any]()
        
        if self.interPageSpacing > 0.0 {
            options[convertFromUIPageViewControllerOptionsKey(UIPageViewController.OptionsKey.interPageSpacing)] = self.interPageSpacing
        }
        
        guard options.count > 0 else {
            return nil
        }
        return options
    }
}

// MARK: - UIPageViewControllerDataSource, PageboyViewControllerDataSource
extension PageboyViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerCount = self.viewControllerCount else {
            return nil
        }

        if let index = self.currentIndex {
            if index != 0 {
                return self.viewController(at: index - 1)
            } else if self.isInfiniteScrollEnabled {
                return self.viewController(at: viewControllerCount - 1)
            }
        }
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerCount = self.viewControllerCount else {
            return nil
        }
        
        if let index = self.currentIndex {
            if index != viewControllerCount - 1 {
                return self.viewController(at: index + 1)
            } else if self.isInfiniteScrollEnabled {
                return self.viewController(at: 0)
            }
        }
        return nil
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalUIPageViewControllerOptionsKeyDictionary(_ input: [String: Any]?) -> [UIPageViewController.OptionsKey: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIPageViewController.OptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIPageViewControllerOptionsKey(_ input: UIPageViewController.OptionsKey) -> String {
	return input.rawValue
}
