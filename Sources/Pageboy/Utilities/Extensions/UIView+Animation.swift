//
//  UIView+Animation.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 26/04/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

extension UIView {
    
    func crossDissolve(duration: TimeInterval = 0.25,
                       during animations: @escaping () -> Void,
                       completion: ((Bool) -> Void)? = nil) {
        UIView.transition(with: self,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations: animations,
                          completion: completion)
    }
}
