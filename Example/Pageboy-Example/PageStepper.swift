//
//  PageStepper.swift
//  Pageboy-Example
//
//  Created by Merrick Sapsford on 24/07/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit
import SnapKit

class PageStepper: UIControl {
    
    private enum ButtonType {
        case negative
        case positive
    }
    
    // MARK: Properties
    
    private var negativeButton: UIButton!
    private var positiveButton: UIButton!
    private var statusLabel: UILabel!
    
    // MARK: Init
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        
        let negativeButton = makeStepperButton(for: .negative)
        addSubview(negativeButton)
        negativeButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.negativeButton = negativeButton
        
        let positiveButton = makeStepperButton(for: .positive)
        addSubview(positiveButton)
        positiveButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.positiveButton = positiveButton
        
        let statusLabel = makeStatusLabel()
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(negativeButton.snp.trailing)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalTo(positiveButton.snp.leading)
        }
        self.statusLabel = statusLabel
    }
}

extension PageStepper {
    
    private func makeStepperButton(for type: ButtonType) -> UIButton {
        let button = SettingsOptionButton()
        
        button.snp.makeConstraints { (make) in
            make.width.equalTo(80.0)
        }
        
        return button
    }
    
    private func makeStatusLabel() -> UILabel {
        let label = UILabel()
        
        return label
    }
}
