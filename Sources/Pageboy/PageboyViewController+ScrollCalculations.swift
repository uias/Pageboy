//
//  PageboyViewController+ScrollCalculations.swift
//  Pageboy iOS
//
//  Created by Merrick Sapsford on 18/10/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

// MARK: - Calculations
internal extension PageboyViewController {
    
    /// Calculate the new page position for a scroll view at its current offset.
    ///
    /// - Parameters:
    ///   - scrollView: Scroll view.
    ///   - currentIndex: Known current page index.
    /// - Returns: New page position & previous page position.
    func calculateNewPagePosition(in scrollView: UIScrollView, currentIndex: PageIndex) -> (CGFloat, CGFloat)? {
        let (pageSize, contentOffset) = calculateRelativePageSizeAndContentOffset(for: scrollView)
        guard let scrollIndexDiff = pageScrollIndexDiff(forCurrentIndex: currentIndex,
                                                        expectedIndex: expectedTransitionIndex,
                                                        currentContentOffset: contentOffset,
                                                        pageSize: pageSize) else {
                                                            return nil
        }
        
        guard let position = calculatePagePosition(for: contentOffset,
                                                   pageSize: pageSize,
                                                   indexDiff: scrollIndexDiff) else {
                                                    return nil
        }
        
        // Return nil if previous position equals current
        let previousPosition = previousPagePosition ?? 0.0
        guard position != previousPosition else {
            return nil
        }
        
        return (position, previousPosition)
    }
    
    /// Calculate the relative page size and content offset for a scroll view at its current position.
    ///
    /// - Parameter scrollView: Scroll View
    /// - Returns: Relative page size and content offset.
    func calculateRelativePageSizeAndContentOffset(for scrollView: UIScrollView) -> (CGFloat, CGFloat) {
        var pageSize: CGFloat
        var contentOffset: CGFloat
        let orientation = navigationOrientation
        switch orientation {
            
        case .horizontal:
            pageSize = scrollView.frame.size.width
            if scrollView.layoutIsRightToLeft {
                contentOffset = pageSize + (pageSize - scrollView.contentOffset.x)
            } else {
                contentOffset = scrollView.contentOffset.x
            }
            
        case .vertical:
            pageSize = scrollView.frame.size.height
            contentOffset = scrollView.contentOffset.y
            
        @unknown default:
            fatalError("unsupported orientation \(orientation.rawValue)")
        }
        
        return (pageSize, contentOffset)
    }
    
    /// Detect whether the scroll view is overscrolling while infinite scroll is enabled
    ///
    /// - Parameter pagePosition: the current page position.
    /// - Returns: The updated page position (if needed).
    func adjustedPagePositionForInfiniteOverscroll(from pagePosition: CGFloat) -> CGFloat? {
        guard isInfinitelyScrolling(forPosition: pagePosition) else {
            return nil
        }
        
        let maxPagePosition = CGFloat((viewControllerCount ?? 1) - 1)
        var integral: Double = 0.0
        var progress = CGFloat(modf(fabs(Double(pagePosition)), &integral))
        var maxInfinitePosition: CGFloat!
        if pagePosition > 0.0 {
            progress = 1.0 - progress
            maxInfinitePosition = 0.0
        } else {
            maxInfinitePosition = maxPagePosition
        }
        
        var infinitePagePosition = maxPagePosition * progress
        if fmod(progress, 1.0) == 0.0 {
            infinitePagePosition = maxInfinitePosition
        }
        
        return infinitePagePosition
    }
    
    /// Whether a position is infinitely scrolling between end ranges
    ///
    /// - Parameter pagePosition: The position.
    /// - Returns: Whether the position is infinitely scrolling.
    func isInfinitelyScrolling(forPosition pagePosition: CGFloat) -> Bool {
        let maxPagePosition = CGFloat((viewControllerCount ?? 1) - 1)
        let isOverscrolling = pagePosition < 0.0 || pagePosition > maxPagePosition
        
        guard isInfiniteScrollEnabled && isOverscrolling else {
            return false
        }
        return true
    }
    
    /// Detects whether a page boundary has been passed.
    /// As pageViewController:didFinishAnimating is not reliable.
    ///
    /// - Parameters:
    ///   - pageOffset: The current page scroll offset
    ///   - scrollView: The scroll view that is being scrolled.
    /// - Returns: Whether a page transition has been detected.
    func detectNewPageIndexIfNeeded(pagePosition: CGFloat, scrollView: UIScrollView) -> Bool {
        guard var currentIndex = currentIndex else {
            return false
        }
        
        // Handle scenario where user continues to pan past a single page range.
        let isPagingForward = pagePosition > previousPagePosition ?? 0.0
        if scrollView.isTracking {
            if isPagingForward && pagePosition >= CGFloat(currentIndex + 1) {
                updateCurrentPageIndexIfNeeded(currentIndex + 1)
                return true
            } else if !isPagingForward && pagePosition <= CGFloat(currentIndex - 1) {
                updateCurrentPageIndexIfNeeded(currentIndex - 1)
                return true
            }
        }
        
        let isOnPage = pagePosition.truncatingRemainder(dividingBy: 1) == 0
        if isOnPage {
            
            // Special case where scroll view might be decelerating but on a new index,
            // and UIPageViewController didFinishAnimating is not called
            if scrollView.isDecelerating {
                currentIndex = Int(pagePosition)
            }
            
            return updateCurrentPageIndexIfNeeded(currentIndex)
        }
        
        return false
    }
    
    /// Safely update the current page index.
    ///
    /// - Parameter index: the proposed index.
    /// - Returns: Whether the page index was updated.
    @discardableResult
    func updateCurrentPageIndexIfNeeded(_ index: Int) -> Bool {
        guard currentIndex != index, index >= 0 && index < viewControllerCount ?? 0 else {
            return false
        }
        currentIndex = index
        return true
    }
    
    /// Calculate the expected index diff for a page scroll.
    ///
    /// - Parameters:
    ///   - index: The current index.
    ///   - expectedIndex: The target page index.
    ///   - currentContentOffset: The current content offset.
    ///   - pageSize: The size of each page.
    /// - Returns: The expected index diff.
    func pageScrollIndexDiff(forCurrentIndex index: Int?,
                             expectedIndex: Int?,
                             currentContentOffset: CGFloat,
                             pageSize: CGFloat) -> CGFloat? {
        guard let index = index else {
            return nil
        }
        
        let expectedIndex = expectedIndex ?? index
        let expectedDiff = CGFloat(max(1, abs(expectedIndex - index)))
        let expectedPosition = calculatePagePosition(for: currentContentOffset,
                                                     pageSize: pageSize,
                                                     indexDiff: expectedDiff) ?? CGFloat(index)
        
        guard !isInfinitelyScrolling(forPosition: expectedPosition) else {
            return 1
        }
        return expectedDiff
    }
    
    /// Calculate the relative page position.
    ///
    /// - Parameters:
    ///   - contentOffset: The current contentOffset.
    ///   - pageSize: The current page size.
    ///   - indexDiff: The expected difference between current / target page indexes.
    /// - Returns: The relative page position.
    func calculatePagePosition(for contentOffset: CGFloat,
                               pageSize: CGFloat,
                               indexDiff: CGFloat) -> CGFloat? {
        guard let currentIndex = currentIndex else {
            return nil
        }
        
        let scrollOffset = contentOffset - pageSize
        let pageOffset = (CGFloat(currentIndex) * pageSize) + (scrollOffset * indexDiff)
        let position = pageOffset / pageSize
        return position.isFinite ? position : 0
    }
    
    /// Update the scroll view contentOffset for bouncing preference if required.
    ///
    /// - Parameter scrollView: The scroll view.
    /// - Returns: Whether the contentOffset was manipulated to achieve bouncing preference.
    @discardableResult
    func updateContentOffsetForBounceIfNeeded(scrollView: UIScrollView) -> Bool {
        guard bounces == false else {
            return false
        }
        
        let previousContentOffset = scrollView.contentOffset
        if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0.0)
        }
        if currentIndex == (viewControllerCount ?? 1) - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0.0)
        }
        return previousContentOffset != scrollView.contentOffset
    }
    
    // MARK: Utilities
    
    /// Check that a scroll view is the actual page view controller managed instance.
    ///
    /// - Parameter scrollView: The scroll view to check.
    /// - Returns: Whether it is the actual managed instance.
    func scrollViewIsActual(_ scrollView: UIScrollView) -> Bool {
        return scrollView === pageViewController?.scrollView
    }
    
    /// Check that a UIPageViewController is the actual managed instance.
    ///
    /// - Parameter pageViewController: The page view controller to check.
    /// - Returns: Whether it is the actual managed instance.
    func pageViewControllerIsActual(_ pageViewController: UIPageViewController) -> Bool {
        return pageViewController === self.pageViewController
    }
}
