//
//  UIView+Localization.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 18/06/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Whether the layout direction of the view is right to left.
    var layoutIsRightToLeft: Bool {
        var layoutDirection: UIUserInterfaceLayoutDirection!
        if Thread.isMainThread {
            layoutDirection = getUserInterfaceLayoutDirection()
        } else {
            DispatchQueue.main.sync {
                layoutDirection = getUserInterfaceLayoutDirection()
            }
        }
        return layoutDirection == .rightToLeft
    }
    
    private func getUserInterfaceLayoutDirection() -> UIUserInterfaceLayoutDirection {
        assert(Thread.isMainThread)
        return UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
    }
    
}
