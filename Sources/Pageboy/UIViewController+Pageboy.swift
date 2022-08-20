//
//  UIViewController+Pageboy.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 18/06/2017.
//  Copyright © 2022 UI At Six. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// The parent PageboyViewController.
    /// Available from any direct child view controllers within a PageboyViewController.
    /// Deprecated in Pageboy 3.1.0.
    @available(*, deprecated, message: "Use pageboyParent")
    public var parentPageboy: PageboyViewController? {
        return pageboyParent
    }
    
    /// The parent PageboyViewController.
    /// Available from any direct child view controllers within a PageboyViewController.
    public var pageboyParent: PageboyViewController? {
        return parent?.parent as? PageboyViewController
    }
    
    /// Page index for this view controller if it's embedded in a PageboyViewController.
    public var pageboyPageIndex: PageboyViewController.PageIndex? {
        return pageboyParent?.pageIndex(of: self)
    }
}
