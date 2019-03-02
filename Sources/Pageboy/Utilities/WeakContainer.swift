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
    private let uuid = UUID().uuidString
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakWrapper: Hashable {
    
    static func == (lhs: WeakWrapper, rhs: WeakWrapper) -> Bool {
        return lhs.object === rhs.object
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid.hashValue)
    }
}
