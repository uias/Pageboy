//
//  PageboyViewController+Updating.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 08/11/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit

internal extension PageboyViewController {
    
    class ViewControllerUpdate {
        
        typealias Completion = ((Bool) -> Void)?
        
        let viewControllers: [UIViewController]
        let direction: UIPageViewControllerNavigationDirection
        let animated: Bool
        let completion: Completion
        
        init(viewControllers: [UIViewController],
             direction: UIPageViewControllerNavigationDirection,
             animated: Bool,
             completion: Completion) {
            self.viewControllers = viewControllers
            self.direction = direction
            self.animated = animated
            self.completion = completion
        }
    }
}

internal extension PageboyViewController {

    internal func performViewControllerUpdate(_ update: ViewControllerUpdate) {
        guard !isUpdatingViewControllers else {
            return
        }
        
        isUpdatingViewControllers = true
        DispatchQueue.main.async {
            self.pageViewController?.setViewControllers(update.viewControllers,
                                                        direction: update.direction,
                                                        animated: update.animated,
                                                        completion:
                { [unowned self] (isFinished) in
                    self.isUpdatingViewControllers = false
                    update.completion?(isFinished)
            })
        }
    }
}
