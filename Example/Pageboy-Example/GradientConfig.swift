//
//  GradientConfig.swift
//  Pageboy-Example
//
//  Created by Merrick Sapsford on 19/07/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

struct GradientConfig {
    
    let topColor: UIColor
    let bottomColor: UIColor
    
    static var defaultGradient: GradientConfig {
        return GradientConfig(topColor: .black, bottomColor: .black)
    }
}
