//
//  PageboyViewController+Updating.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 31/03/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

public extension PageboyViewController {
    
    public enum PageUpdateBehavior {
        case doNothing
        case scrollToUpdate
        case scrollTo(index: PageIndex)
    }
    
    public func insertPage(at index: PageIndex,
                           then updateBehavior: PageUpdateBehavior = .scrollToUpdate) {
        verifyNewPageCount(then: { (pageViewController, oldPageCount, newPageCount) in
            assert(newPageCount > oldPageCount,
                   "Attempt to insert page at \(index) but there are only \(newPageCount) pages after the update")
            
            guard let currentIndex = self.currentIndex else {
                return
            }
            
            guard let newViewController = dataSource?.viewController(for: self, at: index) else {
                assertionFailure("Expected to find inserted UIViewController at page \(index)")
                return
            }
            
            self.viewControllerCount = newPageCount
            viewControllerMap.clear()

            print("Inserting view controller at \(index)")
            
            if index == currentIndex { // replace current view controller
                UIView.transition(with: pageViewController.view,
                                  duration: 0.25,
                                  options: .transitionCrossDissolve, animations: {
                                    self.updateViewControllers(to: [newViewController],
                                                               animated: false,
                                                               async: true,
                                                               completion: nil)
                }, completion: nil)
            } else {
                
                // Increment current index if we're ahead of the insertion
                if currentIndex > index {
                    self.currentIndex = currentIndex + 1
                }

                let scrollUpdate = {
                    switch updateBehavior {
                        
                    case .scrollToUpdate:
                        self.scrollToPage(.at(index: index), animated: true)
                        
                    case .scrollTo(let index):
                        self.scrollToPage(.at(index: index), animated: true)
                        
                    default:()
                    }
                }
                
                // Reload current view controller in UIPageViewController if insertion index is next/previous page.
                if (currentIndex - index) == 1 || (index - currentIndex) == 1 {
                    guard let currentViewController = self.currentViewController else {
                        return
                    }
                    
                    updateViewControllers(to: [currentViewController], animated: false, async: true, completion: { _ in
                        scrollUpdate()
                    })
                } else { // Otherwise just perform scroll update
                    scrollUpdate()
                }
            }
        })
    }
    
    public func deletePage(at index: PageIndex,
                           then updateBehavior: PageUpdateBehavior = .doNothing) {
        verifyNewPageCount(then: { (pageViewController, oldPageCount, newPageCount) in
            assert(newPageCount < oldPageCount,
                   "Attempt to delete page at \(index) but there are \(newPageCount) pages after the update")
            
            let sanitizedIndex = min(index, newPageCount)
            guard let newViewController = dataSource?.viewController(for: self, at: sanitizedIndex) else {
                return
            }
            
            self.viewControllerCount = newPageCount
            viewControllerMap.clear()
            
            if sanitizedIndex == currentIndex {
                UIView.transition(with: pageViewController.view,
                                  duration: 0.25,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.updateViewControllers(to: [newViewController],
                                                               animated: false,
                                                               async: true,
                                                               completion: nil)
                }, completion: nil)
            } else {
                switch updateBehavior {
                    
                case .scrollToUpdate:
                    scrollToPage(.at(index: sanitizedIndex), animated: true)
                    
                case .scrollTo(let index):
                    scrollToPage(.at(index: index), animated: true)
                    
                default:()
                }
            }
        })
    }
    
    // MARK: Utility
    
    private func verifyNewPageCount(then update: (UIPageViewController, Int, Int) -> Void) {
        guard let pageViewController = self.pageViewController else {
            return
        }
        guard let oldPageCount = self.pageCount,
            let newPageCount = dataSource?.numberOfViewControllers(in: self) else {
                return
        }
        update(pageViewController, oldPageCount, newPageCount)
    }
}
