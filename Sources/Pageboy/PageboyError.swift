//
//  PageboyError.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import Foundation

public enum PageboyError: Error {
    
    case outOfBoundsDefaultPageIndex(index: Int)
}
