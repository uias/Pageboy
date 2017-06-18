//
//  LocalizationUtils.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 18/06/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Whether the layout direction of the view is right to left.
    var layoutIsRightToLeft: Bool {
        return UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft
    }
}
