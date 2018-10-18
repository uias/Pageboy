//
//  UIView+AutoLayout.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

internal extension UIView {
    
    @discardableResult
    func pinToSuperviewEdges(priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        let superview = guardForSuperview()
        
        return addConstraints(priority: priority, { () -> [NSLayoutConstraint] in
            return [
                topAnchor.constraint(equalTo: superview.topAnchor),
                leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor)
            ]
        })
    }
    
    @discardableResult
    func matchWidth(to view: UIView,
                    priority: UILayoutPriority = .required) -> NSLayoutConstraint? {
        let constraints = addConstraints(priority: priority, { () -> [NSLayoutConstraint] in
            return [NSLayoutConstraint(item: self,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: view,
                                       attribute: .width,
                                       multiplier: 1.0,
                                       constant: 0.0)]
        })
        
        guard let constraint = constraints.first else {
            fatalError("Could not add matchWidth constraint")
        }
        return constraint
    }
    
    @discardableResult
    func matchHeight(to view: UIView,
                     priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let constraints = addConstraints(priority: priority, { () -> [NSLayoutConstraint] in
            return [NSLayoutConstraint(item: self,
                                       attribute: .height,
                                       relatedBy: .equal,
                                       toItem: view,
                                       attribute: .height,
                                       multiplier: 1.0,
                                       constant: 0.0)]
        })
        
        guard let constraint = constraints.first else {
            fatalError("Could not add matchHeight constraint")
        }
        return constraint
    }
    
    // MARK: Utilities
    
    private func prepareForAutoLayout(_ completion: () -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        completion()
    }
    
    @discardableResult
    private func addConstraints(priority: UILayoutPriority, _ completion: () -> [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        let constraints = completion()
        constraints.forEach({ $0.priority = priority })
        prepareForAutoLayout {
            NSLayoutConstraint.activate(constraints)
        }
        return constraints
    }
    
    private func guardForSuperview() -> UIView {
        guard let superview = superview else {
            fatalError("No superview for view \(self)")
        }
        return superview
    }
}
