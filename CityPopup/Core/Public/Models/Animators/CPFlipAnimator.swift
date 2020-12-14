//
//  CPFlipAnimator.swift
//  CityPopup
//
//  Created by Чилимов Павел on 27.11.2020.
//

import UIKit

public struct CPFlipAnimator: CPAnimatorProtocol {
    
    // MARK: - Private types
    private enum Spec {
        static let perspectiveCoefficient: CGFloat = 0.001
    }
    
    // MARK: - Private properties
    private let direction: CPDirection
    private let showDuration: TimeInterval
    private let hideDuration: TimeInterval
    private let shouldUseFadeAnimation: Bool
    private let isHideAnimationDirectionInverted: Bool
    
    // MARK: - Init
    public init(
        direction: CPDirection = .up,
        showDuration: TimeInterval = 0.3,
        hideDuration: TimeInterval = 0.3,
        shouldUseFadeAnimation: Bool = true,
        isHideAnimationDirectionInverted: Bool = false)
    {
        self.direction = direction
        self.showDuration = showDuration
        self.hideDuration = hideDuration
        self.shouldUseFadeAnimation = shouldUseFadeAnimation
        self.isHideAnimationDirectionInverted = isHideAnimationDirectionInverted
    }
    
}

// MARK: - CPAnimatorProtocol
extension CPFlipAnimator {
    
    public func performShowAnimation(view: UIView, completion: @escaping () -> Void) {
        if shouldUseFadeAnimation {
            view.alpha = 0
        }
        
        flip(view: view)
        view.isHidden = false
        
        UIView.animate(
            withDuration: showDuration,
            delay: 0,
            options: [.curveEaseInOut],
            animations: {
                view.layer.transform = CATransform3DIdentity
                
                if shouldUseFadeAnimation {
                    view.alpha = 1
                }
            },
            completion: { _ in
                completion()
            }
        )
    }
    
    public func performHideAnimation(view: UIView, completion: @escaping () -> Void) {
        UIView.animate(
            withDuration: showDuration,
            delay: 0,
            options: [.curveEaseInOut, .beginFromCurrentState],
            animations: {
                flip(view: view, isHideAnimationDirectionInverted: isHideAnimationDirectionInverted)
                
                if shouldUseFadeAnimation {
                    view.alpha = 0
                }
            },
            completion: { _ in
                completion()
            }
        )
    }
    
}

// MARK: - Private methods
extension CPFlipAnimator {
    
    private func flip(view: UIView, isHideAnimationDirectionInverted: Bool = false) {
        let direction = isHideAnimationDirectionInverted ? self.direction.inverted : self.direction
        var transform = CATransform3DIdentity
        transform.m34 = Spec.perspectiveCoefficient
        
        switch direction {
        case .down:
            transform = CATransform3DRotate(transform, -.pi / 2, 1, 0, 0)
            
        case .left:
            transform = CATransform3DRotate(transform, -.pi / 2, 0, 1, 0)
            
        case .right:
            transform = CATransform3DRotate(transform, .pi / 2, 0, 1, 0)
            
        case .up:
            transform = CATransform3DRotate(transform, .pi / 2, 1, 0, 0)
        }
        
        view.layer.transform = transform
    }
    
}
