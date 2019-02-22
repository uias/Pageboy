//
//  PageboyViewController+Updating.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 31/03/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

extension PageboyViewController {
    
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

// MARK: - Page Updates
internal extension PageboyViewController {
    
    func performUpdates(for newIndex: PageIndex,
                        viewController: UIViewController,
                        updateBehavior: PageUpdateBehavior,
                        indexOperation: (_ currentIndex: PageIndex, _ newIndex: PageIndex) -> Void) {
        guard let currentIndex = currentIndex else {
            return
        }
        
        if newIndex == currentIndex {
            pageViewController?.view.crossDissolve(during: { [weak self, viewController] in
                self?.updateViewControllers(to: [viewController],
                                            animated: false,
                                            async: true,
                                            force: false,
                                            completion: nil)
            })
        } else {
            indexOperation(currentIndex, newIndex)
            
            // Reload current view controller in UIPageViewController if insertion index is next/previous page.
            if pageIndex(newIndex, isNextTo: currentIndex) {
                guard let currentViewController = currentViewController else {
                    return
                }
                
                updateViewControllers(to: [currentViewController], animated: false, async: true, force: false, completion: { [weak self, newIndex, updateBehavior] _ in
                    self?.performScrollUpdate(to: newIndex, behavior: updateBehavior)
                })
            } else { // Otherwise just perform scroll update
                performScrollUpdate(to: newIndex, behavior: updateBehavior)
            }
        }
    }
}

// MARK: - Utilities
extension PageboyViewController {
    
    func verifyNewPageCount(then update: (Int, Int) -> Void) {
        guard let oldPageCount = pageCount,
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
            
        default:
            break
        }
    }
    
    func pageIndex(_ index: PageIndex, isNextTo other: PageIndex) -> Bool {
        return index - other == 1 || other - index == 1
    }
}
