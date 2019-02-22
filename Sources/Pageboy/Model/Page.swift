//
//  Page.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 30/04/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import Foundation

extension PageboyViewController {
 
    /// A page index.
    public typealias PageIndex = Int
    
    /// The index of a page in the page view controller.
    ///
    /// - next: The next page if available.
    /// - previous: The previous page if available.
    /// - first: The first page.
    /// - last: The last page.
    /// - at: A custom specified page index.
    // swiftlint:disable identifier_name
    public enum Page {
        case next
        case previous
        case first
        case last
        case at(index: PageIndex)
    }
}
internal typealias Page = PageboyViewController.Page
internal typealias PageIndex = PageboyViewController.PageIndex

internal extension Page {
    
    /// PageIndex value for page.
    ///
    /// - Parameter pageViewController: PageboyViewController which contains page.
    /// - Returns: PageIndex value.
    func indexValue(in pageViewController: PageboyViewController) -> PageIndex {
        return Page.indexValue(for: self, in: pageViewController)
    }
    
    /// Convert a Page to a PageIndex.
    ///
    /// - Parameters:
    ///   - page: Page to convert.
    ///   - pageViewController: PageboyViewController which contains page.
    /// - Returns: Converted PageIndex.
    static func indexValue(for page: Page,
                           in pageViewController: PageboyViewController) -> PageIndex {
        switch page {

        case .next:
            guard let currentIndex = pageViewController.currentIndex else {
                return 0
            }
            var proposedIndex = currentIndex + 1
            if pageViewController.isInfiniteScrollEnabled && proposedIndex == pageViewController.pageCount { // scroll back to first index
                proposedIndex = 0
            }
            return proposedIndex

        case .previous:
            guard let currentIndex = pageViewController.currentIndex else {
                return 0
            }
            var proposedIndex = currentIndex - 1
            if pageViewController.isInfiniteScrollEnabled && proposedIndex < 0 { // scroll to last index
                proposedIndex = (pageViewController.pageCount ?? 1) - 1
            }
            return proposedIndex

        case .first:
            return 0

        case .last:
            return (pageViewController.pageCount ?? 1) - 1

        case .at(let index):
            return index
        }
    }
}
