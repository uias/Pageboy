//
//  SettingsBulletinPage.swift
//  Pageboy-Example
//
//  Created by Merrick Sapsford on 23/07/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit
import BLTNBoard

class SettingsBulletinPage: BLTNPageItem {
    
    private enum Option {
        case modification
        case infiniteScrolling
        case autoScrolling
        
        var displayTitle: String {
            switch self {
            case .modification:
                return "⚒ Modify Pages"
            case .infiniteScrolling:
                return "🎡 Infinite Scrolling"
            case .autoScrolling:
                return "🏎 Auto Scrolling"
            }
        }
    }
    
    // MARK: Lifecycle
    
    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        let stack = interfaceBuilder.makeGroupStack(spacing: 16.0)
        
        let modificationDetail = makeDetailLabel()
        modificationDetail.text = "⚠️ NEW: In Pageboy 3, you can insert and remove pages dynamically from the page view controller."
        stack.addArrangedSubview(modificationDetail)
        
        let modificationOption = makeOptionButton(for: .modification)
        stack.addArrangedSubview(modificationOption)
        
        let otherDetail = makeDetailLabel()
        otherDetail.text = "Other cool things..."
        stack.addArrangedSubview(otherDetail)
        
        let infiniteScrollOption = makeOptionToggleButton(for: .infiniteScrolling)
        stack.addArrangedSubview(infiniteScrollOption)
        
        let autoScrollOption = makeOptionToggleButton(for: .autoScrolling)
        stack.addArrangedSubview(autoScrollOption)
        
        return [stack]
    }
}

extension SettingsBulletinPage {
    
    private func makeOptionButton(for option: Option) -> SettingsOptionButton {
        
        let button = SettingsOptionButton()
        button.setTitle(option.displayTitle, for: .normal)
        
        return button
    }
    
    private func makeOptionToggleButton(for option: Option) -> SettingsOptionButton {
        let button = makeOptionButton(for: option)
        button.isToggled = true
        return button
    }
    
    private func makeDetailLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }
}
