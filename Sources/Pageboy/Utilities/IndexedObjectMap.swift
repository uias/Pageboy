//
//  ObjectIndexMap.swift
//  Pageboy iOS
//
//  Created by Merrick Sapsford on 02/03/2019.
//  Copyright © 2019 UI At Six. All rights reserved.
//

import Foundation

/// Map which weakly stores an object for an index key.
internal final class IndexedObjectMap<T: AnyObject> {
    
    // MARK: Properties
    
    private var map = [Int: WeakWrapper<T>]()
    
    // MARK: Accessors
    
    func index(for object: T) -> Int? {
        cleanUp()
        return map.first(where: { $0.value.object === object })?.key
    }
 
    // MARK: Mutators
    
    func set(_ index: Int, for object: T) {
        cleanUp()

        let wrapper = WeakWrapper<T>(object)
        map[index] = wrapper
    }
    
    func removeAll() {
        map.removeAll()
    }
    
    private func cleanUp() {
        var invalidIndexes = [Int]()
        map.forEach({
            if $0.value.object == nil {
                invalidIndexes.append($0.key)
            }
        })
        invalidIndexes.forEach({ self.map[$0] = nil })
    }
}
