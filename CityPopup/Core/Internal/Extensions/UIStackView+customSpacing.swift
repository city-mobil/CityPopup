//
//  UIStackView+customSpacing.swift
//  CityPopup
//
//  Created by Чилимов Павел on 11.11.2020.
//

import UIKit

extension UIStackView {
    
    func setSpacing(_ spacing: CGFloat, after view: UIView) {
        if #available(iOS 11.0, *) {
            setCustomSpacing(spacing, after: view)
            
        } else {
            var index: Int?
            for (i, subview) in arrangedSubviews.enumerated() {
                guard subview === view else { continue }
                index = i
                break
            }
            
            guard let stackIndex = index,
                  stackIndex + 1 < arrangedSubviews.count
            else {
                return
            }
            
            let emptyView = UIView()
            emptyView.backgroundColor = backgroundColor
            insertArrangedSubview(emptyView, at: stackIndex + 1)
            
            switch axis {
            case .horizontal:
                emptyView.widthAnchor.constraint(equalToConstant: spacing).isActive = true
                
            case .vertical:
                emptyView.heightAnchor.constraint(equalToConstant: spacing).isActive = true
                
            @unknown default:
                assertionFailure("Unsupported case")
            }
        }
    }
    
}
