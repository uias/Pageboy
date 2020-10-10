//
//  ChildViewController.swift
//  Example tvOS
//
//  Created by Merrick Sapsford on 10/10/2020.
//  Copyright © 2020 UI At Six. All rights reserved.
//

import UIKit

class ChildViewController: UIViewController {

    // MARK: Properties
    
    let page: Int
    
    // MARK: Init
    
    init(page: Int) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        label.text = "Page \(page)"
        label.font = .systemFont(ofSize: 32.0, weight: .medium)
        label.textColor = .white
    }
}
