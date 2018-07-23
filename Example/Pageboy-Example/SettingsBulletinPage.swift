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
        
        var displayTitle: String {
            switch self {
            case .modification:
                return "⚒ Modify Pages"
            case .infiniteScrolling:
                return "🎡 Infinite Scrolling"
            }
        }
    }
    
    // MARK: Lifecycle
    
    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        let stack = interfaceBuilder.makeGroupStack(spacing: 16.0)
        
        let modificationOption = makeOptionButton(for: .modification)
        stack.addArrangedSubview(modificationOption)
        
        let modificationDescription = interfaceBuilder.makeDescriptionLabel()
        modificationDescription.text = "⚠️ NEW: In Pageboy 3, you can insert and remove pages dynamically from the page view controller."
        stack.addArrangedSubview(modificationDescription)
        
        let infiniteScrollOption = makeOptionToggleButton(for: .infiniteScrolling)
        stack.addArrangedSubview(infiniteScrollOption)
        
        return [stack]
    }
}

extension SettingsBulletinPage {
    
    private func makeOptionButton(for option: Option) -> UIButton {
        
        let button = UIButton(type: .system)
        button.setTitle(option.displayTitle, for: .normal)
        button.contentHorizontalAlignment = .center
        
        button.layer.cornerRadius = 12.0
        button.layer.borderWidth = 2.0
        
        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 54.0)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
        
        return button
    }
    
    private func makeOptionToggleButton(for option: Option) -> UIButton {
        let button = makeOptionButton(for: option)
        
        return button
    }
}
