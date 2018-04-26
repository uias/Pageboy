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
            
            guard let newViewController = dataSource?.viewController(for: self, at: index) else {
                assertionFailure("Expected to find inserted UIViewController at page \(index)")
                return
            }
            self.viewControllerCount = newPageCount

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
                switch updateBehavior {
                    
                case .scrollToUpdate:
                    scrollToPage(.at(index: index), animated: true)
                    
                case .scrollTo(let index):
                    scrollToPage(.at(index: index), animated: true)
                    
                default:()
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
