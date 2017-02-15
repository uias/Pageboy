//
//  PageboyAutoLayout.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

internal extension UIView {
    
    @discardableResult func pageboyPinToSuperviewEdges() -> [NSLayoutConstraint]? {
        guard self.superview != nil else {
            return nil
        }
        
        let views = ["view" : self]
        var constraints = [NSLayoutConstraint]()
        let xConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|",
                                                          options: NSLayoutFormatOptions(),
                                                          metrics: nil, views: views)
        let yConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                                          options: NSLayoutFormatOptions(),
                                                          metrics: nil, views: views)
        constraints.append(contentsOf: xConstraints)
        constraints.append(contentsOf: yConstraints)
        
        self.superview?.addConstraints(constraints)
        
        return constraints
    }
}
