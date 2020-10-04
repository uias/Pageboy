//
//  AppDelegate.swift
//  iOS
//
//  Created by Merrick Sapsford on 04/10/2020.
//  Copyright © 2020 UI At Six. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let gradientColors: [UIColor] = [.pageboyPrimary, .pageboySecondary]
        
        let navigationController = UINavigationController(rootViewController: PageViewController())
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = GradientBackgroundViewController(embedding: navigationController, colors: gradientColors)
        window?.makeKeyAndVisible()
        
        return true
    }
}
