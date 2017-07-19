//
//  PageViewController.swift
//  Pageboy-Example
//
//  Created by Merrick Sapsford on 04/01/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit
import Pageboy

class PageViewController: PageboyViewController {
    

    // MARK: Outlets
    
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var gradientView: GradientView!

    
    // MARK: Properties
    
    let gradients: [GradientConfig] = [
        GradientConfig(topColor: UIColor(red:0.01, green:0.00, blue:0.18, alpha:1.0), bottomColor: UIColor(red:0.00, green:0.53, blue:0.80, alpha:1.0)),
        GradientConfig(topColor: UIColor(red:0.20, green:0.08, blue:0.00, alpha:1.0), bottomColor: UIColor(red:0.69, green:0.36, blue:0.00, alpha:1.0)),
        GradientConfig(topColor: UIColor(red:0.00, green:0.13, blue:0.05, alpha:1.0), bottomColor: UIColor(red:0.00, green:0.65, blue:0.33, alpha:1.0)),
        GradientConfig(topColor: UIColor(red:0.18, green:0.00, blue:0.20, alpha:1.0), bottomColor: UIColor(red:0.64, green:0.00, blue:0.66, alpha:1.0)),
        GradientConfig(topColor: UIColor(red:0.20, green:0.00, blue:0.00, alpha:1.0), bottomColor: UIColor(red:0.69, green:0.00, blue:0.00, alpha:1.0))
    ]
    
    var previousBarButton: UIBarButtonItem?
    var nextBarButton: UIBarButtonItem?
    
    let pageControllers: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewControllers = [UIViewController]()
        for i in 0 ..< 5 {
            let viewController = storyboard.instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
            viewController.index = i + 1
            viewControllers.append(viewController)
        }
        return viewControllers
    }()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBarButtons()
        self.view.sendSubview(toBack: self.gradientView)
        
        self.dataSource = self
        self.delegate = self
        
        self.updateGradient(for: self.currentPosition?.x ?? 0.0)
        self.updateStatusLabels()
        self.updateBarButtonStates(index: self.currentIndex ?? 0)
    }

    func updateStatusLabels() {
        let offsetValue =  navigationOrientation == .horizontal ? self.currentPosition?.x : self.currentPosition?.y
        self.offsetLabel.text = "Current Position: " + String(format: "%.3f", offsetValue ?? 0.0)
        self.pageLabel.text = "Current Page: " + String(describing: self.currentIndex ?? 0)
    }
    
    
    // MARK: Actions
    
    @objc func nextPage(_ sender: UIBarButtonItem) {
        self.scrollToPage(.next, animated: true)
    }
    
    @objc func previousPage(_ sender: UIBarButtonItem) {
        self.scrollToPage(.previous, animated: true)
    }
}

// MARK: PageboyViewControllerDataSource
extension PageViewController: PageboyViewControllerDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> PageboyViewController.PageIndex {
        return pageControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return pageControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}

// MARK: PageboyViewControllerDelegate
extension PageViewController: PageboyViewControllerDelegate {
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               willScrollToPageAt index: Int,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        print("willScrollToPageAtIndex: \(index)")
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollTo position: CGPoint,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        print("didScrollToPosition: \(position)")
        
        let isVertical = navigationOrientation == .vertical
        self.updateGradient(for: isVertical ? position.y : position.x)
        self.updateStatusLabels()
        
        self.updateBarButtonStates(index: pageboyViewController.currentIndex ?? 0)
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageAt index: Int,
                               direction: PageboyViewController.NavigationDirection,
                               animated: Bool) {
        print("didScrollToPageAtIndex: \(index)")

        self.updateGradient(for: CGFloat(index))
        self.updateStatusLabels()
        
        self.updateBarButtonStates(index: index)
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didReloadWith currentViewController: UIViewController,
                               currentPageIndex: PageboyViewController.PageIndex) {
    }
}

