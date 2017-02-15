//
//  PageViewController.swift
//  Pageboy-Example
//
//  Created by Merrick Sapsford on 04/01/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit
import Pageboy

class PageViewController: PageboyViewController, PageboyViewControllerDelegate {

    // MARK: Types
    
    struct GradientConfig {
        let topColor: UIColor
        let bottomColor: UIColor
        
        static var defaultGradient: GradientConfig {
            return GradientConfig(topColor: .black, bottomColor: .black)
        }
    }
    
    //
    // MARK: Constants
    //
    
    let numberOfPages = 5
    
    let gradients: [GradientConfig] = [
        GradientConfig(topColor: UIColor.red, bottomColor: UIColor.black),
        GradientConfig(topColor: UIColor.blue, bottomColor: UIColor.black),
        GradientConfig(topColor: UIColor.green, bottomColor: UIColor.black),
        GradientConfig(topColor: UIColor.yellow, bottomColor: UIColor.black),
        GradientConfig(topColor: UIColor.red, bottomColor: UIColor.black)
    ]
    
    //
    // MARK: Outlets
    //
    
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var gradientView: GradientView!

    //
    // MARK: Properties
    //
    
    var previousBarButton: UIBarButtonItem?
    var nextBarButton: UIBarButtonItem?
    
    //
    // MARK: Lifecycle
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBarButtons()
        self.view.sendSubview(toBack: self.gradientView)
        
        self.delegate = self
        self.updateAppearance(pageOffset: 0.0)
    }
    
    // 
    // MARK: Bar Buttons
    //
    
    func addBarButtons() {
        
        let previousBarButton = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(previousPage(_:)))
        let nextBarButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPage(_:)))
        self.navigationItem.setLeftBarButton(previousBarButton, animated: false)
        self.navigationItem.setRightBarButton(nextBarButton, animated: false)
        self.previousBarButton = previousBarButton
        self.nextBarButton = nextBarButton
        
        self.updateBarButtonStates()
    }
    
    @objc func nextPage(_ sender: UIBarButtonItem) {
        self.transitionToPage(.next, animated: true)
    }
    
    @objc func previousPage(_ sender: UIBarButtonItem) {
        self.transitionToPage(.previous, animated: true)
    }
    
    func updateBarButtonStates() {
        self.previousBarButton?.isEnabled = self.currentIndex != 0
        self.nextBarButton?.isEnabled = self.currentIndex != (self.viewControllers?.count ?? 0) - 1
    }
    
    //
    // MARK: PageboyViewControllerDataSource
    //
    
    override func viewControllers(forPageboyViewController pageboyViewController: PageboyViewController) -> [UIViewController]? {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        var viewControllers = [UIViewController]()
        for i in 0..<numberOfPages {
            let viewController = storyboard.instantiateViewController(withIdentifier: "ChildViewController") as! ChildViewController
            viewController.index = i + 1
            viewControllers.append(viewController)
        }
        return viewControllers
    }
    
    //
    // MARK: PageboyViewControllerDelegate
    //
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPosition pagePosition: CGPoint,
                               direction: PageboyViewController.NavigationDirection) {
        
        self.offsetLabel.text = "Current Position: " + String(format: "%.3f", pagePosition.x)
        self.updateAppearance(pageOffset: pagePosition.x)
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               willScrollToPageAtIndex pageIndex: Int,
                               direction: PageboyViewController.NavigationDirection) {
        
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageWithIndex pageIndex: Int,
                               direction: PageboyViewController.NavigationDirection) {
        
        self.pageLabel.text = "Current Page: " + String(describing: pageIndex)
        self.updateBarButtonStates()
        self.updateAppearance(pageOffset: CGFloat(pageIndex))
    }
}

