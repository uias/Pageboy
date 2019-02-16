//
//  DispatchQueue+main.swift
//  Pageboy
//
//  Created by Remi Robert on 2019/02/11.
//  Copyright © 2019 UI At Six. All rights reserved.
//

import UIKit

extension DispatchQueue {

    static func executeInMainThread(callback: @escaping () -> Void) {
        if Thread.isMainThread {
            callback()
        } else {
            DispatchQueue.main.sync(execute: callback)
        }
    }
}
