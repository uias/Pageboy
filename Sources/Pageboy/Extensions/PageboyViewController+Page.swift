//
//  PageboyViewController+Page.swift
//  Pageboy iOS
//
//  Created by Merrick Sapsford on 12/02/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

public extension PageboyViewController {
    
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
