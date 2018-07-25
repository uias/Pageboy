//
//  ChildViewController.swift
//  Pageboy-Example
//
//  Created by Merrick Sapsford on 13/02/2017.
//  Copyright © 2018 UI At Six. All rights reserved.
//

import UIKit

class ChildViewController: UIViewController {

    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var promptLabel: UILabel!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateIndexLabel()
    }
    
    private func updateIndexLabel() {
        if let index = (parentPageboy as? PageViewController)?.viewControllers.index(of: self) {
            label.text = "Page " + String(index + 1)
            promptLabel.isHidden = index != 0
        }
    }
}
