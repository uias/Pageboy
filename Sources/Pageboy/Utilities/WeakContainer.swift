//
//  WeakContainer.swift
//  Pageboy iOS
//
//  Created by Merrick Sapsford on 02/03/2019.
//  Copyright © 2019 UI At Six. All rights reserved.
//

import Foundation

internal final class WeakWrapper<T: AnyObject> {
    
    private(set) weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakWrapper: Equatable {
    
    static func == (lhs: WeakWrapper, rhs: WeakWrapper) -> Bool {
        return lhs.object === rhs.object
    }
}
