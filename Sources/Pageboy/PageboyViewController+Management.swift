//
//  PageboyControllerManagement.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 13/02/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

// MARK: - VC Reloading
extension PageboyViewController {
    
    /// Reload the view controllers in the page view controller.
    /// This reloads the dataSource entirely, calling viewControllers(forPageboyViewController:)
    /// and defaultPageIndex(forPageboyViewController:).
    public func reloadData() {
        reloadData(reloadViewControllers: true)
    }
    
    /// Reload the pages in the PageboyViewController
    ///
    /// - Parameter reloadViewControllers: Reload the view controller data source.
    internal func reloadData(reloadViewControllers: Bool) {

        if reloadViewControllers {
            viewControllerIndexMap.removeAll()
        }

        let newViewControllerCount = dataSource?.numberOfViewControllers(in: self) ?? 0
        viewControllerCount = newViewControllerCount

        let defaultPage = self.dataSource?.defaultPage(for: self) ?? .first
        let defaultIndex = defaultPage.indexValue(in: self)

        guard defaultIndex < newViewControllerCount,
            let viewController = fetchViewController(at: defaultIndex) else {
                return
        }
        
        updateViewControllers(to: [viewController], animated: false, async: false, force: false) { [weak self, defaultIndex, viewController] _ in

            guard let hasSelf = self else {
                /// Self DNE
                return
            }

            hasSelf.currentIndex = defaultIndex
            hasSelf.delegate?.pageboyViewController(hasSelf,
                                                    didReloadWith: viewController,
                                                    currentPageIndex: defaultIndex)
        }
    }
    
    /// Reload the currently active page into the page view controller if possible.
    internal func reloadCurrentPageSoftly() {
        guard let currentIndex = currentIndex else {
            return
        }
        guard let currentViewController = fetchViewController(at: currentIndex) else {
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

        DispatchQueue.executeInMainThread {
            self._updateViewControllers(to: viewControllers,
                                        from: fromIndex,
                                        to: toIndex,
                                        direction: direction,
                                        animated: animated,
                                        async: async,
                                        force: force,
                                        completion: completion)
        }
    }
    
    private func _updateViewControllers(to viewControllers: [UIViewController],
                                        from fromIndex: PageIndex = 0,
                                        to toIndex: PageIndex = 0,
                                        direction: NavigationDirection = .forward,
                                        animated: Bool,
                                        async: Bool,
                                        force: Bool,
                                        completion: TransitionOperation.Completion?) {

        guard let pageViewController = pageViewController else {
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

        let updateBlock = { [weak self, direction, animateUpdate, viewControllers, animated, isUsingCustomTransition] in
            guard let hasSelf = self else {
                return
            }
            pageViewController.setViewControllers(viewControllers,
                                                  direction: direction.layoutNormalized(isRtL: hasSelf.view.layoutIsRightToLeft).rawValue,
                                                  animated: animateUpdate,
                                                  completion: { [weak self, animated, isUsingCustomTransition, completion] (finished) in

                                                        guard let hasSelf = self else {
                                                            return
                                                        }
                                                        hasSelf.isUpdatingViewControllers = false

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
extension PageboyViewController {
    
    /// Load view controller from the data source.
    ///
    /// - Parameter index: Index of the view controller to load.
    /// - Returns: View controller if it exists.
    internal func fetchViewController(at index: PageIndex) -> UIViewController? {
        let viewController = dataSource?.viewController(for: self, at: index)
        if let viewController = viewController {
            viewControllerIndexMap.set(index, for: viewController)
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
    func setUpPageViewController(reloadViewControllers: Bool = true) {
        let existingZIndex: Int?
        if let pageViewController = self.pageViewController { // destroy existing page VC
            existingZIndex = view.subviews.firstIndex(of: pageViewController.view)
            destroyCurrentPageViewController()
        } else {
            existingZIndex = nil
        }
        
        let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: navigationOrientation,
                                                      options: pageViewControllerOptions)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        self.pageViewController = pageViewController
        
        #if swift(>=4.2)
        addChild(pageViewController)
        #else
        addChildViewController(pageViewController)
        #endif
        if let existingZIndex = existingZIndex {
            view.insertSubview(pageViewController.view, at: existingZIndex)
        } else {
            view.addSubview(pageViewController.view)
            #if swift(>=4.2)
            view.sendSubviewToBack(pageViewController.view)
            #else
            view.sendSubview(toBack: pageViewController.view)
            #endif
        }
        pageViewController.view.pinToSuperviewEdges()
        #if swift(>=4.2)
        pageViewController.didMove(toParent: self)
        #else
        pageViewController.didMove(toParentViewController: self)
        #endif
        
        pageViewController.scrollView?.delegate = self
        pageViewController.view.backgroundColor = .clear
        pageViewController.scrollView?.delaysContentTouches = delaysContentTouches
        pageViewController.scrollView?.isScrollEnabled = isScrollEnabled
        pageViewController.scrollView?.isUserInteractionEnabled = isUserInteractionEnabled
        
        reloadData(reloadViewControllers: reloadViewControllers)
    }
    
    private func destroyCurrentPageViewController() {
        pageViewController?.view.removeFromSuperview()
        #if swift(>=4.2)
        pageViewController?.removeFromParent()
        #else
        pageViewController?.removeFromParentViewController()
        #endif
        pageViewController = nil
    }
    
    /// Re-initialize the internal UIPageViewController instance without reloading data source if it currently exists.
    func reconfigurePageViewController() {
        guard pageViewController != nil else {
            return
        }
        setUpPageViewController(reloadViewControllers: false)
    }
    
    #if swift(>=4.2)
    /// The options to be passed to a UIPageViewController instance.
    var pageViewControllerOptions: [UIPageViewController.OptionsKey: Any]? {
        var options = [UIPageViewController.OptionsKey: Any]()
        
        if interPageSpacing > 0.0 {
            options[.interPageSpacing] = interPageSpacing
        }
        
        guard !options.isEmpty else {
            return nil
        }
        return options
    }
    #else
    /// The options to be passed to a UIPageViewController instance.
    var pageViewControllerOptions: [String: Any]? {
        var options = [String: Any]()
        
        if interPageSpacing > 0.0 {
            options[UIPageViewControllerOptionInterPageSpacingKey] = interPageSpacing
        }
        
        guard !options.isEmpty else {
            return nil
        }
        return options
    }
    #endif
}

// MARK: - UIPageViewControllerDataSource, PageboyViewControllerDataSource
extension PageboyViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerCount = viewControllerCount else {
            return nil
        }

        if let index = currentIndex {
            if index != 0 {
                return fetchViewController(at: index - 1)
            } else if isInfiniteScrollEnabled {
                return fetchViewController(at: viewControllerCount - 1)
            }
        }
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerCount = viewControllerCount else {
            return nil
        }

        if let index = currentIndex {
            if index != viewControllerCount - 1 {
                return fetchViewController(at: index + 1)
            } else if isInfiniteScrollEnabled {
                return fetchViewController(at: 0)
            }
        }
        return nil
    }
}
