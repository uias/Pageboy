//
//  PageboyViewController+ChildScrollObservation.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 04/03/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

extension PageboyViewController: ScrollObservationServiceDelegate {
    
    func scrollObservationService(_ service: ScrollObservationService,
                                  didObserveOffsetChangeFor viewController: UIViewController,
                                  on scrollView: UIScrollView,
                                  contentOffset: CGPoint) {
        if #available(iOS 11, *) {
            invisibleScrollView?.contentOffset = contentOffset
        }
    }
}
