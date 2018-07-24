//
//  PageModificationBulletinPage.swift
//  Pageboy-Example
//
//  Created by Merrick Sapsford on 23/07/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit
import BLTNBoard

class PageModificationBulletinPage: BLTNPageItem {
    
    // MARK: Lifecycle
    
    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        let stack = interfaceBuilder.makeGroupStack(spacing: 16.0)
        
        let intentPrompt = makePromptLabel()
        intentPrompt.text = "I want to"
        stack.addArrangedSubview(intentPrompt)
        
        let indexPrompt = makePromptLabel()
        indexPrompt.text = "at page index"
        stack.addArrangedSubview(indexPrompt)
        
        let stepper = makePageStepper()
        stack.addArrangedSubview(stepper)
        
        return [stack]
    }
}

extension PageModificationBulletinPage {
    
    private func makePromptLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
    
    private func makePageStepper() -> PageStepper {
        let stepper = PageStepper()
        
        return stepper
    }
}
