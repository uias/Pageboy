//
//  PageboyStatusView.swift
//  Examples
//
//  Created by Merrick Sapsford on 10/10/2020.
//  Copyright © 2020 UI At Six. All rights reserved.
//

import UIKit
import Pageboy

class PageboyStatusView: UIView {
    
    // MARK: Properties
    
    private let divider = UIView()
    private let countLabel = UILabel()
    private let positionLabel = UILabel()
    private let pageLabel = UILabel()
    
    override var tintColor: UIColor! {
        didSet {
            updateForTintColor()
        }
    }
    
    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        addSubview(divider)
        addSubview(stackView)
        divider.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.topAnchor.constraint(equalTo: topAnchor),
            divider.widthAnchor.constraint(equalToConstant: 1.0),
            bottomAnchor.constraint(equalTo: divider.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: divider.trailingAnchor, constant: 8.0),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
        
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(positionLabel)
        stackView.addArrangedSubview(pageLabel)
        
        updateCount(nil)
        updatePosition(nil)
        updatePage(nil)
        
        tintColor = UIColor.white.withAlphaComponent(0.75)
        
        switch traitCollection.userInterfaceIdiom {
        case .tv:
            countLabel.font = .systemFont(ofSize: 18)
            positionLabel.font = .systemFont(ofSize: 18)
            pageLabel.font = .systemFont(ofSize: 18)
        default:
            countLabel.font = .systemFont(ofSize: 14)
            positionLabel.font = .systemFont(ofSize: 14)
            pageLabel.font = .systemFont(ofSize: 14)
        }
        
        updateForTintColor()
    }
    
    // MARK: Styling
    
    private func updateForTintColor() {
        divider.backgroundColor = tintColor
        countLabel.textColor = tintColor
        positionLabel.textColor = tintColor
        pageLabel.textColor = tintColor
    }
    
    // MARK: Data
    
    private func updateCount(_ count: Int?) {
        countLabel.text = "Page Count: \(count ?? 0)"
    }
    
    private func updatePosition(_ position: CGFloat?) {
        positionLabel.text = "Current Position: \(String(format: "%.3f", position ?? 0.0))"
    }
    
    private func updatePage(_ page: Int?) {
        pageLabel.text = "Current Page: \(page ?? 0)"
    }
}

extension PageboyStatusView: PageboyViewControllerDelegate {
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollTo position: CGPoint, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        switch pageboyViewController.navigationOrientation {
        case .horizontal:
            updatePosition(position.x)
        case .vertical:
            updatePosition(position.y)
        @unknown default:
            break
        }
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, willScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didScrollToPageAt index: PageboyViewController.PageIndex, direction: PageboyViewController.NavigationDirection, animated: Bool) {
        updatePage(index)
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didCancelScrollToPageAt index: PageboyViewController.PageIndex, returnToPageAt previousIndex: PageboyViewController.PageIndex) {
        
    }
    
    func pageboyViewController(_ pageboyViewController: PageboyViewController, didReloadWith currentViewController: UIViewController, currentPageIndex: PageboyViewController.PageIndex) {
        updateCount(pageboyViewController.pageCount)
    }
}

extension PageboyStatusView {
    
    class func add(to viewController: PageboyViewController) {
        
        let statusView = PageboyStatusView()
        viewController.delegate = statusView
        
        viewController.view.addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statusView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 16.0),
            viewController.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: statusView.bottomAnchor, constant: 8.0)
        ])
    }
}
