//
//  SettingsBulletinPage.swift
//  Pageboy-Example
//
//  Created by Merrick Sapsford on 23/07/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit
import BLTNBoard
import Pageboy

class SettingsBulletinPage: BLTNPageItem {
    
    // MARK: Options
    
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
    
    // MARK: Properties
    
    private weak var pageViewController: PageboyViewController!
    
    private var modificationOption: UIButton!
    private var infiniteScrollOption: UIButton!
    private var autoScrollOption: UIButton!
    
    // MARK: Init
    
    init(title: String, pageViewController: PageboyViewController) {
        self.pageViewController = pageViewController
        super.init(title: title)
    }
    
    // MARK: Lifecycle
    
    override func tearDown() {
        modificationOption.removeTarget(self, action: nil, for: .touchUpInside)
        infiniteScrollOption.removeTarget(self, action: nil, for: .touchUpInside)
        autoScrollOption.removeTarget(self, action: nil, for: .touchUpInside)
    }
    
    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        let stack = interfaceBuilder.makeGroupStack(spacing: 16.0)
        
        let modificationDetail = makeDetailLabel()
        modificationDetail.text = "⚠️ NEW: In Pageboy 3, you can insert and remove pages dynamically from the page view controller."
        stack.addArrangedSubview(modificationDetail)
        
        let modificationOption = makeOptionButton(for: .modification)
        stack.addArrangedSubview(modificationOption)
        self.modificationOption = modificationOption
        
        let otherDetail = makeDetailLabel()
        otherDetail.text = "Other cool things..."
        stack.addArrangedSubview(otherDetail)
        
        let infiniteScrollOption = makeOptionToggleButton(for: .infiniteScrolling)
        infiniteScrollOption.addTarget(self, action: #selector(infiniteScrollToggled(_:)), for: .touchUpInside)
        infiniteScrollOption.isSelected = pageViewController.isInfiniteScrollEnabled
        stack.addArrangedSubview(infiniteScrollOption)
        self.infiniteScrollOption = infiniteScrollOption
        
        let autoScrollOption = makeOptionToggleButton(for: .autoScrolling)
        autoScrollOption.addTarget(self, action: #selector(autoScrollToggled(_:)), for: .touchUpInside)
        autoScrollOption.isSelected = pageViewController.autoScroller.isEnabled
        stack.addArrangedSubview(autoScrollOption)
        self.autoScrollOption = autoScrollOption
        
        return [stack]
    }
    
    // MARK: Actions
    
    @objc private func modificationOptionPressed(_ sender: UIButton) {
        
    }
    
    @objc private func infiniteScrollToggled(_ sender: UIButton) {
        pageViewController.isInfiniteScrollEnabled = sender.isSelected
    }
    
    @objc private func autoScrollToggled(_ sender: UIButton) {
        if sender.isSelected {
            pageViewController.autoScroller.enable()
        } else {
            pageViewController.autoScroller.disable()
        }
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
