//
//  PageViewController.swift
//  Pageboy-Example
//
//  Created by Merrick Sapsford on 04/01/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit
import Pageboy

class PageViewController: PageboyViewController {
    
    // MARK: Properties
    
    @IBOutlet private weak var statusView: PageStatusView!
    private var gradient: GradientViewController? {
        return parent as? GradientViewController
    }
    var previousBarButton: UIBarButtonItem?
    var nextBarButton: UIBarButtonItem?
    
    var viewControllers: [UIViewController] = {
        let storyboard = UIStoryboard(name: "Pageboy", bundle: Bundle.main)
        
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
        
        dataSource = self
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gradient?.gradients = Gradients.all
        addBarButtonsIfNeeded()
    }
    
    // MARK: Actions
    
    @objc func nextPage(_ sender: UIBarButtonItem) {
        scrollToPage(.next, animated: true)
    }
    
    @objc func previousPage(_ sender: UIBarButtonItem) {
        scrollToPage(.previous, animated: true)
    }
}

// MARK: PageboyViewControllerDataSource
extension PageViewController: PageboyViewControllerDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        let count = viewControllers.count
        statusView.numberOfPages = count
        return count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> Page? {
        return nil
    }
}

// MARK: PageboyViewControllerDelegate
extension PageViewController: PageboyViewControllerDelegate {
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               willScrollToPageAt index: Int,
                               direction: NavigationDirection,
                               animated: Bool) {
//        print("willScrollToPageAtIndex: \(index)")
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollTo position: CGPoint,
                               direction: NavigationDirection,
                               animated: Bool) {
//        print("didScrollToPosition: \(position)")
        
        let relativePosition = navigationOrientation == .vertical ? position.y : position.x
        gradient?.gradientOffset = relativePosition
        statusView.currentPosition = relativePosition
        
        updateBarButtonsForCurrentIndex()
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didScrollToPageAt index: Int,
                               direction: NavigationDirection,
                               animated: Bool) {
//        print("didScrollToPageAtIndex: \(index)")

        gradient?.gradientOffset = CGFloat(index)
        statusView.currentIndex = index
        updateBarButtonsForCurrentIndex()
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController,
                               didReloadWith currentViewController: UIViewController,
                               currentPageIndex: PageIndex) {
    }
}

