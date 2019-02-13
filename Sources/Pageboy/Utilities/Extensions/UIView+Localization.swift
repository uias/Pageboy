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
        DispatchQueue.executeInMainThread {
            layoutDirection = self.getUserInterfaceLayoutDirection()
        }
        return layoutDirection == .rightToLeft
    }
    
    private func getUserInterfaceLayoutDirection() -> UIUserInterfaceLayoutDirection {
        return UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
    }

}
