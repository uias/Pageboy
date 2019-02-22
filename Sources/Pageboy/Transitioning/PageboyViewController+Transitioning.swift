//
//  PageboyViewController+Transitioning.swift
//  Pageboy
//
//  Created by Merrick Sapsford on 29/05/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

// MARK: - PageboyViewController transition configuration.
extension PageboyViewController {
    
    /// Transition for a page scroll.
    public final class Transition {
        
        /// Style for the transition.
        ///
        /// - push: Slide the new page in (Default).
        /// - fade: Fade the new page in.
        /// - moveIn: Move the new page in over the top of the current page.
        /// - reveal: Reveal the new page under the current page.
        public enum Style: String {
            case push
            case fade
            case moveIn
            case reveal
        }
        
        /// The style for the transition.
        public let style: Style
        /// The duration of the transition.
        public let duration: TimeInterval
        
        // MARK: Init
        
        /// Initialize a transition.
        ///
        /// - Parameters:
        ///   - style: The style to use.
        ///   - duration: The duration to transition for.
        public init(style: Style, duration: TimeInterval) {
            self.style = style
            self.duration = duration
        }
    }
}

// MARK: - Custom PageboyViewController transitioning.
internal extension PageboyViewController {
    
    // MARK: Set Up
    
    private func prepareForTransition() {
        guard transitionDisplayLink == nil else {
            return
        }

        let displayLink = CADisplayLink(target: self, selector: #selector(displayLinkDidTick))
        displayLink.isPaused = true
        #if swift(>=4.2)
        displayLink.add(to: .main, forMode: .common)
        #else
        displayLink.add(to: .main, forMode: .commonModes)
        #endif
        transitionDisplayLink = displayLink
    }
    
    private func clearUpAfterTransition() {
        transitionDisplayLink?.invalidate()
        transitionDisplayLink = nil
    }
    
    // MARK: Animation
    
    @objc func displayLinkDidTick() {
        self.activeTransitionOperation?.tick()
    }
    
    /// Perform a transition to a new page index.
    ///
    /// - Parameters:
    ///   - from: The current index.
    ///   - to: The new index.
    ///   - direction: The direction of travel.
    ///   - animated: Whether to animate the transition.
    ///   - completion: Action on the completion of the transition.
    func performTransition(from startIndex: Int,
                           to endIndex: Int,
                           with direction: NavigationDirection,
                           animated: Bool,
                           completion: @escaping TransitionOperation.Completion) {

        guard let transition = transition, animated == true, activeTransitionOperation == nil else {
                completion(false)
                return
        }
        guard let scrollView = pageViewController?.scrollView else {
            #if DEBUG
            fatalError("Can't find UIPageViewController scroll view")
            #else
            return
            #endif
        }

        prepareForTransition()

        /// Calculate semantic direction for RtL languages
        var semanticDirection = direction
        if view.layoutIsRightToLeft && navigationOrientation == .horizontal {
            semanticDirection = direction.layoutNormalized(isRtL: view.layoutIsRightToLeft)
        }

        // create a transition and unpause display link
        let action = TransitionOperation.Action(startIndex: startIndex,
                                                endIndex: endIndex,
                                                direction: direction,
                                                semanticDirection: semanticDirection,
                                                orientation: navigationOrientation)
        activeTransitionOperation = TransitionOperation(for: transition,
                                                        action: action,
                                                        delegate: self)
        transitionDisplayLink?.isPaused = false

        // start transition
        activeTransitionOperation?.start(on: scrollView.layer,
                                         completion: completion)
    }
}

extension PageboyViewController: TransitionOperationDelegate {
    
    func transitionOperation(_ operation: TransitionOperation,
                             didFinish finished: Bool) {
        transitionDisplayLink?.isPaused = true
        activeTransitionOperation = nil

        clearUpAfterTransition()
    }
    
    func transitionOperation(_ operation: TransitionOperation,
                             didUpdateWith percentComplete: CGFloat) {

        let isReverse = operation.action.direction == .reverse
        let isVertical = operation.action.orientation == .vertical

        /// Take into account the diff between startIndex and endIndex
        let indexDiff = abs(operation.action.endIndex - operation.action.startIndex)
        let diff = percentComplete * CGFloat(indexDiff)

        let index = CGFloat(currentIndex ?? 0)
        let position = isReverse ? index - diff : index + diff
        let point = CGPoint(x: isVertical ? 0.0 : position,
                            y: isVertical ? position : 0.0)

        currentPosition = point
        delegate?.pageboyViewController(self, didScrollTo: point,
                                             direction: operation.action.direction,
                                             animated: true)
        previousPagePosition = position
    }
}

internal extension CATransition {
    
    func configure(from: PageboyViewController.Transition) {
        duration = from.duration
        #if swift(>=4.2)
        type = CATransitionType(rawValue: from.style.rawValue)
        #else
        type = from.style.rawValue
        #endif
    }
}
