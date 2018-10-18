//
//  ParentMatchedScrollView.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 04/03/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

/// UIScrollView which has a content view that matches a parent view's height & width.
internal final class ParentMatchedScrollView: UIScrollView {
    
    // MARK: Properties
    
    private let contentView = UIView()
    
    // MARK: Init
    
    static func matching(parent: UIView) -> ParentMatchedScrollView {
        let scrollView = ParentMatchedScrollView(frame: .zero)
        parent.addSubview(scrollView)
        
        let contentView = scrollView.contentView
        scrollView.addSubview(contentView)
        contentView.pinToSuperviewEdges()
        contentView.matchWidth(to: parent)
        contentView.matchHeight(to: parent)
        
        return scrollView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(for: )")
    }
}
