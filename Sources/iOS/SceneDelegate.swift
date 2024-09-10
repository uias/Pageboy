//
//  SceneDelegate.swift
//  Example iOS
//
//  Created by Merrick Sapsford on 11/10/2020.
//  Copyright © 2020 UI At Six. All rights reserved.
//

import UIKit

// swiftlint:disable weak_delegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var toolbarDelegate = ToolbarDelegate()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else {
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
        
        let pageViewController = PageViewController()
        PageboyStatusView.add(to: pageViewController)
        
        #if targetEnvironment(macCatalyst)
                
        let toolbar = NSToolbar(identifier: "main")
        toolbar.delegate = toolbarDelegate
        toolbar.displayMode = .iconOnly
                
        if let titlebar = windowScene.titlebar {
            titlebar.toolbar = toolbar
            titlebar.toolbarStyle = .automatic
        }
        
        pageViewController.registerForNavigationNotifications()
        let contentViewController = pageViewController
        
        #else
        let navigationController = NavigationController(navigationBarClass: TransparentNavigationBar.self, toolbarClass: nil)
        navigationController.viewControllers = [pageViewController]
        let contentViewController = navigationController
        #endif
        
        let gradientColors: [UIColor] = [.pageboyPrimary, .pageboySecondary]
        window.rootViewController = GradientBackgroundViewController(embedding: contentViewController, colors: gradientColors)
        
        self.window = window
        window.makeKeyAndVisible()
    }
}
