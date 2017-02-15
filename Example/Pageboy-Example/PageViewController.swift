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

    //
    // MARK: Outlets
    //
    
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!
    
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
        
        self.delegate = self
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
        for i in 0..<5 {
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
                               didScrollToOffset pageOffset: CGPoint,
                               direction: PageboyViewController.NavigationDirection) {
        self.offsetLabel.text = "Current Offset: " + String(describing: pageOffset.x)
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
    }
}

