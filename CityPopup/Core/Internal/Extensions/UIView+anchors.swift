//
//  UIView+anchors.swift
//  CityPopup
//
//  Created by Чилимов Павел on 14.10.2020.
//

import UIKit

extension UIView {
    
    func set(
        anchor: CPAttributes.Anchor,
        toView view: UIView,
        shouldConsiderLayoutGuide: Bool)
    {
        let (mainLayoutXAxisAnchor, mainLayoutYAxisAnchor) = getAxisesAnchors(
            fromView: self,
            anchorPoint: anchor.mainAnchorPoint
        )
        let (secondaryLayoutXAxisAnchor, secondaryLayoutYAxisAnchor) = shouldConsiderLayoutGuide
            ? getAxisesAnchors(fromLayoutGuide: view.layoutMarginsGuide, anchorPoint: anchor.toAnchorPoint)
            : getAxisesAnchors(fromView: view, anchorPoint: anchor.toAnchorPoint)
        
        let xAxisConstraint = mainLayoutXAxisAnchor.constraint(equalTo: secondaryLayoutXAxisAnchor)
        let yAxisConstraint = mainLayoutYAxisAnchor.constraint(equalTo: secondaryLayoutYAxisAnchor)
        
        xAxisConstraint.isActive = true
        xAxisConstraint.priority = .required
        yAxisConstraint.isActive = true
        yAxisConstraint.priority = .required
    }
    
    private func getAxisesAnchors(
        fromView view: UIView,
        anchorPoint: CPAttributes.AnchorPoint) -> (xAxisAnchor: NSLayoutXAxisAnchor, yAxisAnchor: NSLayoutYAxisAnchor)
    {
        switch anchorPoint {
        case .leftTop: return (view.leftAnchor, view.topAnchor)
        case .centerTop: return (view.centerXAnchor, view.topAnchor)
        case .rightTop: return (view.rightAnchor, view.topAnchor)
        case .leftCenter: return (view.leftAnchor, view.centerYAnchor)
        case .center: return (view.centerXAnchor, view.centerYAnchor)
        case .rightCenter: return (view.rightAnchor, view.centerYAnchor)
        case .leftBottom: return (view.leftAnchor, view.bottomAnchor)
        case .centerBottom: return (view.centerXAnchor, view.bottomAnchor)
        case .rightBottom: return (view.rightAnchor, view.bottomAnchor)
        }
    }
    
    private func getAxisesAnchors(
        fromLayoutGuide layoutGuide: UILayoutGuide,
        anchorPoint: CPAttributes.AnchorPoint) -> (xAxisAnchor: NSLayoutXAxisAnchor, yAxisAnchor: NSLayoutYAxisAnchor)
    {
        switch anchorPoint {
        case .leftTop: return (layoutGuide.leftAnchor, layoutGuide.topAnchor)
        case .centerTop: return (layoutGuide.centerXAnchor, layoutGuide.topAnchor)
        case .rightTop: return (layoutGuide.rightAnchor, layoutGuide.topAnchor)
        case .leftCenter: return (layoutGuide.leftAnchor, layoutGuide.centerYAnchor)
        case .center: return (layoutGuide.centerXAnchor, layoutGuide.centerYAnchor)
        case .rightCenter: return (layoutGuide.rightAnchor, layoutGuide.centerYAnchor)
        case .leftBottom: return (layoutGuide.leftAnchor, layoutGuide.bottomAnchor)
        case .centerBottom: return (layoutGuide.centerXAnchor, layoutGuide.bottomAnchor)
        case .rightBottom: return (layoutGuide.rightAnchor, layoutGuide.bottomAnchor)
        }
    }
    
}
