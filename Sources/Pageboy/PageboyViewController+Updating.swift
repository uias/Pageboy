//
//  PageboyViewController+Updating.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 31/03/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

public extension PageboyViewController {
    
    /// Behavior to evaluate after a page update.
    ///
    /// - doNothing: Do nothing.
    /// - scrollToUpdate: Scroll to the update.
    /// - scrollTo: Scroll to a specified index.
    public enum PageUpdateBehavior {
        case doNothing
        case scrollToUpdate
        case scrollTo(index: PageIndex)
    }
}

public extension PageboyViewController {
    
    /// Insert a new page into the page view controller.
    ///
    /// - Parameters:
    ///   - index: The index to insert the page at.
    ///   - updateBehavior: Behavior to execute after the page was inserted.
    public func insertPage(at index: PageIndex,
                           then updateBehavior: PageUpdateBehavior = .scrollToUpdate) {
        verifyNewPageCount(then: { (oldPageCount, newPageCount) in
            assert(newPageCount > oldPageCount,
                   "Attempt to insert page at \(index) but there are only \(newPageCount) pages after the update")
            
            guard let newViewController = dataSource?.viewController(for: self, at: index) else {
                assertionFailure("Expected to find inserted UIViewController at page \(index)")
                return
            }
            
            self.viewControllerCount = newPageCount
            viewControllerMap.clear()

            performUpdates(for: index,
                           viewController: newViewController,
                           updateBehavior: updateBehavior,
                           indexOperation: { (currentIndex, newIndex) in
                            
                            if currentIndex > newIndex {
                                self.currentIndex = currentIndex + 1
                            }
            })
        })
    }
    
    /// Delete an existing page from the page view controller.
    ///
    /// - Parameters:
    ///   - index: The index to delete the page from.
    ///   - updateBehavior: Behavior to execute after the page was deleted.
    public func deletePage(at index: PageIndex,
                           then updateBehavior: PageUpdateBehavior = .doNothing) {
        verifyNewPageCount(then: { (oldPageCount, newPageCount) in
            assert(index < oldPageCount,
                   "Attempting to delete page at \(index) but there were only \(oldPageCount) pages before the update")
            assert(newPageCount < oldPageCount,
                   "Attempt to delete page at \(index) but there are \(newPageCount) pages after the update")
            
            let sanitizedIndex = min(index, newPageCount - 1)
            guard let newViewController = dataSource?.viewController(for: self, at: sanitizedIndex) else {
                return
            }
            
            self.viewControllerCount = newPageCount
            viewControllerMap.clear()
            
            performUpdates(for: sanitizedIndex,
                           viewController: newViewController,
                           updateBehavior: updateBehavior,
                           indexOperation: { (currentIndex, newIndex) in
                            
                            if currentIndex > newIndex {
                                self.currentIndex = currentIndex - 1
                            }
            })
        })
    }
}

// MARK: - Updating
private extension PageboyViewController {
    
    func performUpdates(for newIndex: PageIndex,
                        viewController: UIViewController,
                        updateBehavior: PageUpdateBehavior,
                        indexOperation: (_ currentIndex: PageIndex, _ newIndex: PageIndex) -> Void) {
        guard let currentIndex = self.currentIndex else {
            return
        }
        
        if newIndex == currentIndex {
            pageViewController?.view.crossDissolve(during: {
                self.updateViewControllers(to: [viewController],
                                           animated: false,
                                           async: true,
                                           force: false,
                                           completion: nil)
            })
        } else {
            indexOperation(currentIndex, newIndex)
            
            // Reload current view controller in UIPageViewController if insertion index is next/previous page.
            if pageIndex(newIndex, isNextTo: currentIndex) {
                guard let currentViewController = self.currentViewController else {
                    return
                }
                
                updateViewControllers(to: [currentViewController], animated: false, async: true, force: false, completion: { _ in
                    self.performScrollUpdate(to: newIndex, behavior: updateBehavior)
                })
            } else { // Otherwise just perform scroll update
                performScrollUpdate(to: newIndex, behavior: updateBehavior)
            }
        }
    }
}

// MARK: - Utilities
private extension PageboyViewController {
    
    func verifyNewPageCount(then update: (Int, Int) -> Void) {
        guard let oldPageCount = self.pageCount,
            let newPageCount = dataSource?.numberOfViewControllers(in: self) else {
                return
        }
        update(oldPageCount, newPageCount)
    }
    
    func performScrollUpdate(to update: PageIndex, behavior: PageUpdateBehavior) {
        switch behavior {
            
        case .scrollToUpdate:
            scrollToPage(.at(index: update), animated: true)
            
        case .scrollTo(let index):
            scrollToPage(.at(index: index), animated: true)
            
        default:()
        }
    }
    
    func pageIndex(_ index: PageIndex, isNextTo other: PageIndex) -> Bool {
        return index - other == 1 || other - index == 1
    }
}
