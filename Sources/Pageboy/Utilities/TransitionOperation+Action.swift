//
//  TransitionOperation+Action.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 30/05/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import Foundation

internal extension TransitionOperation {
    
    struct Action {
        
        let startIndex: Int
        let endIndex: Int
        let direction: PageboyViewController.NavigationDirection
        
    }
}
