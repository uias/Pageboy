//
//  NavigationController.swift
//  Example iOS
//
//  Created by Merrick Sapsford on 10/10/2020.
//  Copyright © 2020 UI At Six. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    open override var childForStatusBarStyle: UIViewController? {
        topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        topViewController
    }
    
    open override var childForHomeIndicatorAutoHidden: UIViewController? {
        topViewController
    }
}
