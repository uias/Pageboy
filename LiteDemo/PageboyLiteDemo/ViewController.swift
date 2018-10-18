//
//  ViewController.swift
//  PageboyLiteDemo
//
//  Created by Merrick Sapsford on 18/10/2018.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit
import Pageboy

class ViewController: UIViewController {

    let pageboyViewController = PageboyViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addChild(pageboyViewController)
        view.addSubview(pageboyViewController.view)
        pageboyViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageboyViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageboyViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageboyViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageboyViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        pageboyViewController.didMove(toParent: self)
    }


}

