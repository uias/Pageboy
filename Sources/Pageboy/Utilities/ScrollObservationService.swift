//
//  ScrollObservationService.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 04/03/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

internal protocol ScrollObservationServiceDelegate: class {
    
    func scrollObservationService(_ service: ScrollObservationService,
                                  didObserveOffsetChangeFor viewController: UIViewController,
                                  on scrollView: UIScrollView,
                                  contentOffset: CGPoint)
}

internal class ScrollObservationService {
    
    private(set) lazy var registrations = [Int: UIViewController]()
    private var tokens = [Int: NSKeyValueObservation?]()
    
    weak var delegate: ScrollObservationServiceDelegate?
    
    // MARK: Registration
    
    func register(viewController: UIViewController, for index: Int) {
        if let existingRegistration = registrations[index], existingRegistration === viewController {
            return
        }
        
        registrations[index] = viewController
        hook(registration: viewController)
    }
    
    func unregister(index: Int) {
        if let viewController = registrations[index] {
            unhook(registration: viewController)
            registrations.removeValue(forKey: index)
        }
    }
    
    // MARK: Evaluation
    
    private func unhook(registration: UIViewController) {
        let viewController = registration
        tokens.removeValue(forKey: viewController.hash)
    }
    
    private func hook(registration: UIViewController) {
        let viewController = registration
        for scrollView in viewController.view.scrollViewSubviews {
            let token = scrollView.observe(\.contentOffset, changeHandler: { [weak self] (scrollView, _) in
                if let self = self {
                    self.delegate?.scrollObservationService(self,
                                                            didObserveOffsetChangeFor: viewController,
                                                            on: scrollView,
                                                            contentOffset: scrollView.contentOffset)
                }
            })
            tokens[viewController.hash] = token
        }
    }
}

private extension UIView {
    
    var scrollViewSubviews: [UIScrollView] {
        var scrollViews = [UIScrollView]()
        subviews.forEach { (subview) in
            if let scrollView = subview as? UIScrollView {
                scrollViews.append(scrollView)
            }
        }
        return scrollViews
    }
}
