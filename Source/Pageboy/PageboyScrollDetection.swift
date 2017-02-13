//
//  PageboyScrollDetection.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 13/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import Foundation

// MARK: - UIPageViewControllerDelegate, UIScrollViewDelegate
extension PageboyViewController: UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController],
                                   transitionCompleted completed: Bool) {
        guard completed == true else {
            return
        }
        
        if let viewController = pageViewController.viewControllers?.first,
            let index = self.viewControllers?.index(of: viewController) {
            self.currentPageIndex = index
        }
        
    }
    
    // MARK: UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageWidth = scrollView.frame.size.width
        let scrollOffset = scrollView.contentOffset.x - pageWidth
        let pageOffset = (CGFloat(self.currentPageIndex) * pageWidth) + scrollOffset
        
        // do not continue if a page change is detected
        guard !self.detectCurrentPageIndexIfNeeded(pageOffset: pageOffset, scrollView: scrollView) else {
            return
        }
        
        // do not continue if previous offset equals current
        if let previousPageOffset = self.previousPageOffset, previousPageOffset == pageOffset {
            return
        }
        
        // provide scroll updates
        print(pageOffset)
        
        self.previousPageOffset = pageOffset
    }
    
    /// Detects whether a page boundary has been passed.
    /// As pageViewController:didFinishAnimating is not reliable.
    ///
    /// - Parameters:
    ///   - pageOffset: The current page scroll offset
    ///   - scrollView: The scroll view that is being scrolled.
    /// - Returns: Whether a page transition has been detected.
    private func detectCurrentPageIndexIfNeeded(pageOffset: CGFloat, scrollView: UIScrollView) -> Bool {
        let pagePosition = pageOffset / scrollView.frame.size.width
        
        let isPagingForward = pageOffset > previousPageOffset ?? 0.0
        if scrollView.isDragging {
            if isPagingForward && pagePosition >= CGFloat(self.currentPageIndex + 1) {
                self.updateCurrentPageIndexIfNeeded(self.currentPageIndex + 1)
                return true
            } else if !isPagingForward && pagePosition <= CGFloat(self.currentPageIndex - 1) {
                self.updateCurrentPageIndexIfNeeded(self.currentPageIndex - 1)
                return true
            }
        }
        
        return false
    }
    
    /// Safely update the current page index.
    ///
    /// - Parameter index: the proposed index.
    private func updateCurrentPageIndexIfNeeded(_ index: Int) {
        guard self.currentPageIndex != index, index >= 0 &&
            index < self.viewControllers?.count ?? 0 else {
                return
        }
        self.currentPageIndex = index
    }
}
