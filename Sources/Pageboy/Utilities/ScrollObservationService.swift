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
    
    private(set) lazy var registrations = [UIViewController]()
    private var tokens = [Int: NSKeyValueObservation?]()
    
    weak var delegate: ScrollObservationServiceDelegate?
    
    // MARK: Registration
    
    func register(viewControllers: [UIViewController]) {
        viewControllers.forEach { (viewController) in
            guard self.registrations.contains(viewController) == false else {
                return
            }
            self.registrations.append(viewController)
            self.hook(registration: viewController)
        }
    }
    
    func unregister(viewControllers: [UIViewController]) {
        viewControllers.forEach { (viewController) in
            if let index = self.registrations.index(of: viewController) {
                self.unhook(registration: viewController)
                self.registrations.remove(at: index)
            }
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
            let token = scrollView.observe(\.contentOffset, changeHandler: { (scrollView, _) in
                self.delegate?.scrollObservationService(self,
                                                        didObserveOffsetChangeFor: viewController,
                                                        on: scrollView,
                                                        contentOffset: scrollView.contentOffset)
            })
            tokens[viewController.hash] = token
        }
    }
}

private extension UIView {
    
    var scrollViewSubviews: [UIScrollView] {
        var scrollViews = [UIScrollView]()
        self.subviews.forEach { (subview) in
            if let scrollView = subview as? UIScrollView {
                scrollViews.append(scrollView)
            }
        }
        return scrollViews
    }
}
