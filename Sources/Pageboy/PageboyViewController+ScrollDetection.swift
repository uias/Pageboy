//
//  PageboyScrollDetection.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 13/02/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

// MARK: - UIPageViewControllerDelegate
extension PageboyViewController: UIPageViewControllerDelegate {
    
    // MARK: UIPageViewControllerDelegate
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   willTransitionTo pendingViewControllers: [UIViewController]) {
        guard pageViewControllerIsActual(pageViewController) else {
            return
        }

        self.pageViewController(pageViewController,
                                willTransitionTo: pendingViewControllers,
                                animated: false)
    }
    
    internal func pageViewController(_ pageViewController: UIPageViewController,
                                     willTransitionTo pendingViewControllers: [UIViewController],
                                     animated: Bool) {
        guard pageViewControllerIsActual(pageViewController) else {
            return
        }
        
        guard let viewController = pendingViewControllers.first,
            let index = viewControllerIndexMap.index(for: viewController) else {
                return
        }

        expectedTransitionIndex = index
        let direction = NavigationDirection.forPage(index, previousPage: currentIndex ?? index)
        delegate?.pageboyViewController(self,
                                        willScrollToPageAt: index,
                                        direction: direction,
                                        animated: animated)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController],
                                   transitionCompleted completed: Bool) {
        defer {
            expectedTransitionIndex = nil
        }
        
        guard pageViewControllerIsActual(pageViewController) else {
            return }
                
        guard completed else {
            guard let expectedIndex = expectedTransitionIndex else {
                return }
            
            guard let viewController = previousViewControllers.first,
                let previousIndex = viewControllerIndexMap.index(for: viewController) else {
                    return
            }
            
            delegate?.pageboyViewController(self,
                                            didCancelScrollToPageAt: expectedIndex,
                                            returnToPageAt: previousIndex)
            return }
        
        guard let viewController = pageViewController.viewControllers?.first,
            let index = viewControllerIndexMap.index(for: viewController),
            index == expectedTransitionIndex else {
            return }

        updateCurrentPageIndexIfNeeded(index)
    }
}

// MARK: - UIScrollViewDelegate
extension PageboyViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let currentIndex = currentIndex, scrollViewIsActual(scrollView) else {
            return
        }
        guard updateContentOffsetForBounceIfNeeded(scrollView: scrollView) == false else {
            return
        }

        guard let (newPosition, previousPosition) = calculateNewPagePosition(in: scrollView, currentIndex: currentIndex) else {
            return
        }
        
        // do not continue if a page change is detected
        let didDetectNewPage = detectNewPageIndexIfNeeded(pagePosition: newPosition,
                                                          scrollView: scrollView)
        guard !didDetectNewPage else {
            return
        }

        // update page position for infinite overscroll if required
        let pagePosition: CGFloat
        if let infiniteAdjustedPosition = adjustedPagePositionForInfiniteOverscroll(from: newPosition) {
            pagePosition = infiniteAdjustedPosition
        } else {
            pagePosition = newPosition
        }

        // provide scroll updates
        var positionPoint: CGPoint!
        let direction = NavigationDirection.forPosition(pagePosition, previous: previousPosition)
        if navigationOrientation == .horizontal {
            positionPoint = CGPoint(x: pagePosition, y: scrollView.contentOffset.y)
        } else {
            positionPoint = CGPoint(x: scrollView.contentOffset.x, y: pagePosition)
        }

        // ignore duplicate updates
        guard currentPosition != positionPoint else {
            return
        }
        currentPosition = positionPoint
        delegate?.pageboyViewController(self,
                                        didScrollTo: positionPoint,
                                        direction: direction,
                                        animated: isScrollingAnimated)
        previousPagePosition = pagePosition
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollViewIsActual(scrollView) else {
            return
        }
        if autoScroller.cancelsOnScroll {
            autoScroller.cancel()
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard scrollViewIsActual(scrollView) else {
            return
        }
        self.scrollView(didEndScrolling: scrollView)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollViewIsActual(scrollView) else {
            return
        }
        self.scrollView(didEndScrolling: scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                          withVelocity velocity: CGPoint,
                                          targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollViewIsActual(scrollView) else {
            return
        }

        updateContentOffsetForBounceIfNeeded(scrollView: scrollView)
    }
    
    private func scrollView(didEndScrolling scrollView: UIScrollView) {
        guard scrollViewIsActual(scrollView) else {
            return
        }

        if autoScroller.restartsOnScrollEnd {
            autoScroller.restart()
        }
    }
}
