//
//  NavigationControllerUtils.swift
//  Pageboy-Example
//
//  Created by Merrick Sapsford on 10/04/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if let rootViewController = self.viewControllers.first {
            return rootViewController.preferredStatusBarStyle
        }
        return super.preferredStatusBarStyle
    }
}
