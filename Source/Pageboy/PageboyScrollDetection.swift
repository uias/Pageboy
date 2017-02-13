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
        let previousPageOffset = self.previousPageOffset ?? 0.0
        
        // calculate offset / page size for relative orientation
        var pageSize: CGFloat!
        var contentOffset: CGFloat!
        if self.navigationOrientation == .horizontal {
            pageSize = scrollView.frame.size.width
            contentOffset = scrollView.contentOffset.x
        } else {
            pageSize = scrollView.frame.size.height
            contentOffset = scrollView.contentOffset.y
        }
        
        let scrollOffset = contentOffset - pageSize
        let pageOffset = (CGFloat(self.currentPageIndex) * pageSize) + scrollOffset
        let pagePosition = pageOffset / pageSize
        
        // do not continue if a page change is detected
        guard !self.detectCurrentPageIndexIfNeeded(pageOffset: pageOffset,
                                                   pagePosition: pagePosition,
                                                   scrollView: scrollView) else {
            return
        }
        
        // do not continue if previous offset equals current
        if let previousPageOffset = self.previousPageOffset, previousPageOffset == pageOffset {
            return
        }
        
        // provide scroll updates
        var offsetPoint: CGPoint!
        let direction: NavigationDirection = pageOffset > previousPageOffset ? .progressive : .regressive
        if self.navigationOrientation == .horizontal {
            offsetPoint = CGPoint(x: pageOffset, y: scrollView.contentOffset.y)
        } else {
            offsetPoint = CGPoint(x: scrollView.contentOffset.x, y: pageOffset)
        }
        self.delegate?.pageboyViewController(self,
                                             didScrollToOffset: offsetPoint,
                                             direction: direction)
        
        self.previousPageOffset = pageOffset
    }
    
    /// Detects whether a page boundary has been passed.
    /// As pageViewController:didFinishAnimating is not reliable.
    ///
    /// - Parameters:
    ///   - pageOffset: The current page scroll offset
    ///   - scrollView: The scroll view that is being scrolled.
    /// - Returns: Whether a page transition has been detected.
    private func detectCurrentPageIndexIfNeeded(pageOffset: CGFloat, pagePosition: CGFloat, scrollView: UIScrollView) -> Bool {
        
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
