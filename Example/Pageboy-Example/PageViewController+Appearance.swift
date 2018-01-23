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
        
        let lowerGradient = gradient(forIndex: lowerIndex)
        let upperGradient = gradient(forIndex: upperIndex)
        
        if let topColor = interpolate(betweenColor: lowerGradient.topColor,
                                      and: upperGradient.topColor,
                                      percent: percentage),
            let bottomColor = interpolate(betweenColor: lowerGradient.bottomColor,
                                          and: upperGradient.bottomColor,
                                          percent: percentage) {
            self.gradientView.colors = [topColor, bottomColor]
        }
        
    }
    
    func gradient(forIndex index: Int) -> GradientConfig {
        guard index >= 0 && index < gradients.count else {
            return .defaultGradient
        }
        
        return gradients[index]
    }
    
    func interpolate(betweenColor colorA: UIColor,
                     and colorB: UIColor,
                     percent: CGFloat) -> UIColor? {
        var redA: CGFloat = 0.0
        var greenA: CGFloat = 0.0
        var blueA: CGFloat = 0.0
        var alphaA: CGFloat = 0.0
        guard colorA.getRed(&redA, green: &greenA, blue: &blueA, alpha: &alphaA) else {
            return nil
        }
        
        var redB: CGFloat = 0.0
        var greenB: CGFloat = 0.0
        var blueB: CGFloat = 0.0
        var alphaB: CGFloat = 0.0
        guard colorB.getRed(&redB, green: &greenB, blue: &blueB, alpha: &alphaB) else {
            return nil
        }
        
        let iRed = CGFloat(redA + percent * (redB - redA))
        let iBlue = CGFloat(blueA + percent * (blueB - blueA))
        let iGreen = CGFloat(greenA + percent * (greenB - greenA))
        let iAlpha = CGFloat(alphaA + percent * (alphaB - alphaA))
        
        return UIColor(red: iRed, green: iGreen, blue: iBlue, alpha: iAlpha)
    }
}

