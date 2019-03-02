//
//  ObjectIndexMap.swift
//  Pageboy iOS
//
//  Created by Merrick Sapsford on 02/03/2019.
//  Copyright © 2019 UI At Six. All rights reserved.
//

import Foundation

/// Map which stores an index next to an object.
internal final class ObjectIndexMap<T: AnyObject> {
    
    // MARK: Properties
    
    private var map = [WeakWrapper<T>: Int]()
    
    // MARK: Accessors
    
    func index(for object: T) -> Int? {
        cleanUp()
        return map.first(where: { $0.key.object === object })?.value
    }
 
    // MARK: Mutators
    
    func set(_ index: Int, for object: T) {
        cleanUp()

        let wrapper = WeakWrapper<T>(object)
        map[wrapper] = index
    }
    
    func removeAll() {
        map.removeAll()
    }
    
    private func cleanUp() {
        var invalidObjects = [WeakWrapper<T>]()
        map.forEach({
            if $0.key.object == nil {
                invalidObjects.append($0.key)
            }
        })
        invalidObjects.forEach({ self.map[$0] = nil })
    }
}
