//
//  PageViewControllerAppearance.swift
//  Pageboy-Example
//
//  Created by Merrick Sapsford on 15/02/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

extension PageViewController {
    
    // MARK: Bar buttons
    
    func addBarButtons() {
        
        let previousBarButton = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(previousPage(_:)))
        let nextBarButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPage(_:)))
        navigationItem.setLeftBarButton(previousBarButton, animated: false)
        navigationItem.setRightBarButton(nextBarButton, animated: false)
        self.previousBarButton = previousBarButton
        self.nextBarButton = nextBarButton
        
        updateBarButtonStates(index: currentIndex ?? 0)
    }
    
    func updateBarButtonStates(index: Int) {
        self.previousBarButton?.isEnabled = index != 0
        self.nextBarButton?.isEnabled = index != (pageCount ?? 0) - 1
    }
    

    // MARK: Appearance

    func updateGradient(for pageOffset: CGFloat) {
        
        var offset = pageOffset
        if offset < 0.0 {
            offset = 1.0 + offset
        }
        
        var integral: Double = 0.0
        let percentage = CGFloat(modf(Double(offset), &integral))
        let lowerIndex = Int(floor(pageOffset))
        let upperIndex = Int(ceil(pageOffset))
        
        let lowerGradient = gradient(for: lowerIndex)
        let upperGradient = gradient(for: upperIndex)
        
        if let top = lowerGradient.top.interpolate(between: upperGradient.top, percent: percentage),
            let bottom = lowerGradient.bottom.interpolate(between: upperGradient.bottom, percent: percentage) {
            gradientView.colors = [top, bottom]
        }
    }
    
    func gradient(for index: Int) -> Gradient {
        guard index >= 0 && index < gradients.count else {
            return .defaultGradient
        }
        
        return gradients[index]
    }
}

