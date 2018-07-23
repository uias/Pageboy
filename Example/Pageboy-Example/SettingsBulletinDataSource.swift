//
//  SettingsBulletinDataSource.swift
//  Pageboy-Example
//
//  Created by Merrick Sapsford on 21/07/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit
import BLTNBoard

enum SettingsBulletinDataSource {
 
    // MARK: Pages
    
    static func makeIntroPage() -> BLTNPageItem {
        let page = BLTNPageItem(title: "Pageboy")
        page.descriptionText = "A simple, highly informative page view controller."
        page.image = #imageLiteral(resourceName: "ic_welcome_icon")
        page.actionButtonTitle = "Continue"
        page.isDismissable = false
        page.actionHandler = { item in
            item.manager?.dismissBulletin()
        }
        return page
    }
    
    static func makeSettingsPage() -> BLTNPageItem {
        let page = SettingsBulletinPage(title: "Settings")
        
        page.actionButtonTitle = "Done"
        return page
    }
}

extension SettingsBulletinDataSource {
    
    static func makePageboyAppearance(tintColor: UIColor?) -> BLTNItemAppearance {
        let appearance = BLTNItemAppearance()
        if let tintColor = tintColor {
            appearance.actionButtonColor = tintColor
        }
        return appearance
    }
}
