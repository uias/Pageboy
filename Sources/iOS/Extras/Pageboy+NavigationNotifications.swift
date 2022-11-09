//
//  Pageboy+NavigationNotifications.swift
//  Example iOS
//
//  Created by Merrick Sapsford on 11/10/2020.
//  Copyright © 2020 UI At Six. All rights reserved.
//

import UIKit
import Pageboy

extension Notification.Name {
    
    static let nextPage = Notification.Name("com.uias.Pageboy.nextPage")
    static let previousPage = Notification.Name("com.uias.Pageboy.previousPage")
}

extension PageboyViewController {
    
    func registerForNavigationNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(nextPage(_:)), name: .nextPage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(previousPage(_:)), name: .previousPage, object: nil)
    }
    
    @objc private func nextPage(_ sender: Notification) {
        // TODO: Implement scroll to next page
    }
    
    @objc private func previousPage(_ sender: Notification) {
        // TODO: Implement scroll to previous page
    }
}
