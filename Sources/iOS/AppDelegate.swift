//
//  AppDelegate.swift
//  iOS
//
//  Created by Merrick Sapsford on 04/10/2020.
//  Copyright © 2020 UI At Six. All rights reserved.
//

import UIKit
import Pageboy

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let gradientColors: [UIColor] = [.pageboyPrimary, .pageboySecondary]
        
        let pageViewController = PageViewController()
        addStatusView(to: pageViewController)
        let navigationController = NavigationController(navigationBarClass: TransparentNavigationBar.self, toolbarClass: nil)
        navigationController.viewControllers = [pageViewController]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = GradientBackgroundViewController(embedding: navigationController, colors: gradientColors)
        window?.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegate {
    
    private func addStatusView(to viewController: PageboyViewController) {
        
        let statusView = PageboyStatusView()
        viewController.delegate = statusView
        
        viewController.view.addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11, *) {
            NSLayoutConstraint.activate([
                statusView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 16.0),
                viewController.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 8.0)
            ])
        } else {
            NSLayoutConstraint.activate([
                statusView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 16.0),
                viewController.view.bottomAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 8.0)
            ])
        }
    }
}
