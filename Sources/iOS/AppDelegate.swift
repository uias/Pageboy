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
        PageboyStatusView.add(to: pageViewController)
        let navigationController = NavigationController(navigationBarClass: TransparentNavigationBar.self, toolbarClass: nil)
        navigationController.viewControllers = [pageViewController]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = GradientBackgroundViewController(embedding: navigationController, colors: gradientColors)
        window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
