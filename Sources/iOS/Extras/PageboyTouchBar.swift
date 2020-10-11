//
//  PageboyTouchBar.swift
//  Example iOS
//
//  Created by Merrick Sapsford on 11/10/2020.
//  Copyright © 2020 UI At Six. All rights reserved.
//

import UIKit
import Pageboy

#if targetEnvironment(macCatalyst)

extension NSTouchBarItem.Identifier {
    static let nextPage = NSTouchBarItem.Identifier("com.uias.Pageboy.nextPage")
    static let previousPage = NSTouchBarItem.Identifier("com.uias.Pageboy.previousPage")
}

extension PageViewController: NSTouchBarDelegate {
    
    open override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        
        touchBar.defaultItemIdentifiers = [
            .previousPage,
            .nextPage,
            .flexibleSpace
        ]
        
        return touchBar
    }
    
    public func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let touchBarItem: NSTouchBarItem?
                
                switch identifier {
                
                case .previousPage:
                    guard let image = UIImage(systemName: "chevron.left") else {
                        return nil
                    }
                    touchBarItem = NSButtonTouchBarItem(identifier: identifier,
                                                        image: image,
                                                        target: self,
                                                        action: #selector(PageViewController.previousPage(_:)))
                    
                case .nextPage:
                    guard let image = UIImage(systemName: "chevron.right") else {
                        return nil
                    }
                    touchBarItem = NSButtonTouchBarItem(identifier: identifier,
                                                        image: image,
                                                        target: self,
                                                        action: #selector(PageViewController.nextPage(_:)))

                default:
                    touchBarItem = nil
                }
                
                return touchBarItem
    }
}

#endif
