//
//  AnimatedPressViewProtocol.swift
//  CityPopup
//
//  Created by Чилимов Павел on 06.11.2020.
//

import UIKit

private enum Animation {
    
    static let scaleKey = "transform.scale"
    static let backgroundKey = "backgroundColor"
    
}

protocol AnimatedPressViewProtocol where Self: UIView {}

extension AnimatedPressViewProtocol {
    
    func playPressAnimation(
        scale: CGFloat,
        backgroundColor: UIColor,
        duration: TimeInterval,
        includingViews: [UIView] = [])
    {
        CATransaction.setAnimationDuration(duration)
        let timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        CATransaction.setAnimationTimingFunction(timingFunction)
        
        let defaultInitialScale = sqrt(transform.a * transform.a + transform.c * transform.c)
        let scaleAnimation = layer.createScaleAnimation(targetScale: scale, defaultInitialScale: defaultInitialScale)
        
        let backgroundColorAnimation = layer.createBackgroundColorAnimation(targetColor: backgroundColor.cgColor)
        
        layer.add(scaleAnimation, forKey: Animation.scaleKey)
        layer.add(backgroundColorAnimation, forKey: Animation.backgroundKey)
        
        includingViews.forEach { view in
            view.layer.add(backgroundColorAnimation, forKey: Animation.backgroundKey)
        }
    }
    
}

extension CALayer {
    
    fileprivate func createScaleAnimation(targetScale: CGFloat, defaultInitialScale: CGFloat) -> CABasicAnimation {
        let initialScale = presentation()?.transform.m11 ?? defaultInitialScale
        
        let scaleAnimation = CABasicAnimation(keyPath: Animation.scaleKey)
        scaleAnimation.fromValue = initialScale
        scaleAnimation.toValue = targetScale
        scaleAnimation.fillMode = .both
        scaleAnimation.isRemovedOnCompletion = false
        
        return scaleAnimation
    }
    
    fileprivate func createBackgroundColorAnimation(targetColor: CGColor) -> CABasicAnimation {
        let initialColor = presentation()?.backgroundColor ?? backgroundColor
        
        let colorAnimation = CABasicAnimation(keyPath: Animation.backgroundKey)
        colorAnimation.fromValue = initialColor
        colorAnimation.toValue = targetColor
        colorAnimation.fillMode = .both
        colorAnimation.isRemovedOnCompletion = false
        
        return colorAnimation
    }
    
}
