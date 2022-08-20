//
//  PageboyViewController+Updating.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 31/03/2018.
//  Copyright © 2022 UI At Six. All rights reserved.
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
    
    internal enum UpdateOperation {
        case insert
        case delete
    }
}

// MARK: - Page Updates
internal extension PageboyViewController {
    
    func performUpdates(for newIndex: PageIndex?,
                        viewController: UIViewController?,
                        update: (operation: UpdateOperation, behavior: PageUpdateBehavior),
                        indexOperation: (_ currentIndex: PageIndex, _ newIndex: PageIndex) -> Void,
                        completion: ((Bool) -> Void)?) {
        guard let newIndex = newIndex, let viewController = viewController else { // no view controller - reset
            updateViewControllers(to: [UIViewController()],
                                  animated: false,
                                  async: false,
                                  force: false,
                                  completion: completion)
            self.currentIndex = nil
            return
        }
        
        guard let currentIndex = currentIndex else { // if no `currentIndex` - currently have no pages - set VC and index.
            updateViewControllers(to: [viewController],
                                  animated: false,
                                  async: false,
                                  force: false,
                                  completion: completion)
            self.currentIndex = newIndex
            return
        }
        
        // If we are inserting a page that is lower/equal to the current index
        // we have to move the current page up therefore we can't just cross-dissolve.
        let isInsertionThatRequiresMoving = update.operation == .insert && newIndex <= currentIndex
        
        if !isInsertionThatRequiresMoving && newIndex == currentIndex { // currently on the page for the update.
            pageViewController?.view.crossDissolve(during: { [weak self, viewController] in
                self?.updateViewControllers(to: [viewController],
                                            animated: false,
                                            async: true,
                                            force: false,
                                            completion: completion)
            })
        } else { // update is happening on some other page.
            indexOperation(currentIndex, newIndex)
            
            // If we are deleting, check if the new index is greater than the current. If it is then we
            // dont need to do anything...
            if update.operation == .delete && newIndex > currentIndex {
                completion?(true)
                return
            }
            
            // Reload current view controller in UIPageViewController if insertion index is next/previous page.
            if pageIndex(newIndex, isNextTo: currentIndex) {
                
                let newViewController: UIViewController
                switch update.operation {
                    
                case .insert:
                    guard let currentViewController = currentViewController else {
                        completion?(true)
                        return
                    }
                    newViewController = currentViewController
                    
                case .delete:
                    newViewController = viewController
                }
                
                updateViewControllers(to: [newViewController], animated: false, async: true, force: false, completion: { [weak self, newIndex, update] _ in
                    self?.performScrollUpdate(to: newIndex, behavior: update.behavior)
                    completion?(true)
                })
            } else { // Otherwise just perform scroll update
                performScrollUpdate(to: newIndex, behavior: update.behavior)
                completion?(true)
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
