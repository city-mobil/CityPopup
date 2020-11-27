//
//  UIView+embedInScrollView.swift
//  CityPopup
//
//  Created by Чилимов Павел on 09.11.2020.
//

import UIKit

extension UIView {
    
    func embedInScrollView(
        view: UIView,
        offsets: UIEdgeInsets,
        scrollingByAxis axis: NSLayoutConstraint.Axis,
        backgroundColor: UIColor?)
    {
        let scrollView = SwipeableScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = backgroundColor
        
        if let stackView = self as? UIStackView {
            stackView.addArrangedSubview(scrollView)
        } else {
            addSubview(scrollView)
            NSLayoutConstraint.activate([
                scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                scrollView.topAnchor.constraint(equalTo: topAnchor),
                scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = backgroundColor
        
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        switch axis {
        case .horizontal:
            containerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
            containerView.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor).isActive = true
            
        case .vertical:
            containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            let containerHeightConstraint = containerView.heightAnchor.constraint(equalTo: heightAnchor)
            containerHeightConstraint.priority = .defaultHigh
            containerHeightConstraint.isActive = true
            
        @unknown default:
            assertionFailure("Unsupported case")
        }
        
        containerView.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: offsets.left),
            view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: offsets.top),
            view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -offsets.right),
            view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -offsets.bottom)
        ])
    }
    
}
