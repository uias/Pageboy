//
//  TransparentNavigationBar.swift
//  Example iOS
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2022 UI At Six. All rights reserved.
//

import UIKit

class TransparentNavigationBar: UINavigationBar {
    
    private let separatorView = UIView()
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        var titleTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        titleTextAttributes[.font] = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.semibold)
        self.titleTextAttributes = titleTextAttributes
        self.tintColor = UIColor.white.withAlphaComponent(0.7)
        
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        
        separatorView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.addSubview(separatorView)
        separatorView.frame = CGRect(x: 0.0,
                                     y: self.bounds.size.height - 1.0,
                                     width: self.bounds.size.width, height: 0.5)
    }

    // MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        separatorView.frame = CGRect(x: 0.0,
                                     y: self.bounds.size.height - 1.0,
                                     width: self.bounds.size.width, height: 0.5)
    }
}
