//
//  ToolbarDelegate.swift
//  Example iOS
//
//  Created by Merrick Sapsford on 11/10/2020.
//  Copyright © 2020 UI At Six. All rights reserved.
//

import UIKit

class ToolbarDelegate: NSObject {

}

#if targetEnvironment(macCatalyst)

extension NSToolbarItem.Identifier {
    static let nextPage = NSToolbarItem.Identifier("com.uias.Pageboy.nextPage")
    static let previousPage = NSToolbarItem.Identifier("com.uias.Pageboy.previousPage")
}

extension ToolbarDelegate {
    
    @objc func nextPage(_ sender: Any?) {
        NotificationCenter.default.post(Notification(name: .nextPage))
    }
    
    @objc func previousPage(_ sender: Any?) {
        NotificationCenter.default.post(Notification(name: .previousPage))
    }
}

extension ToolbarDelegate: NSToolbarDelegate {
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        let identifiers: [NSToolbarItem.Identifier] = [
            .previousPage,
            .nextPage
        ]
        return identifiers
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarDefaultItemIdentifiers(toolbar)
    }
    
    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var toolbarItem: NSToolbarItem?
        
        switch itemIdentifier {
        
        case .nextPage:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.image = UIImage(systemName: "chevron.right")
            item.label = "Next Page"
            item.action = #selector(nextPage(_:))
            item.target = self
            toolbarItem = item
            
        case .previousPage:
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.image = UIImage(systemName: "chevron.left")
            item.label = "Previous Page"
            item.action = #selector(previousPage(_:))
            item.target = self
            toolbarItem = item
            
        default:
            toolbarItem = nil
        }
        
        return toolbarItem
    }
}
#endif
