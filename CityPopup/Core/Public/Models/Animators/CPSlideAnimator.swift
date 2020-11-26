//
//  CPSlideAnimator.swift
//  CityPopup
//
//  Created by Чилимов Павел on 10.11.2020.
//

import UIKit

public struct CPSlideAnimator: CPAnimatorProtocol {
    
    // MARK: - Private properties
    private let direction: CPDirection
    private var translation: CGFloat?
    private let showDuration: TimeInterval
    private let hideDuration: TimeInterval
    private let shouldUseFadeAnimation: Bool
    
    // MARK: - Init
    /// - Parameters:
    ///   - direction: Direction for show animation. Direction for hide animation will be inverted.
    ///   - translation: Specify distance of movement to shown position. Set `nil` so that the distance will be calculated automatically.
    ///   - showDuration: Duration of show animation.
    ///   - hideDuration: Duration of hide animation.
    ///   - shouldUseFadeAnimation: Specify will be fade animation used or not.
    public init(
        direction: CPDirection = .up,
        translation: CGFloat? = nil,
        showDuration: TimeInterval = 0.3,
        hideDuration: TimeInterval = 0.3,
        shouldUseFadeAnimation: Bool = true)
    {
        self.direction = direction
        self.translation = translation
        self.showDuration = showDuration
        self.hideDuration = hideDuration
        self.shouldUseFadeAnimation = shouldUseFadeAnimation
    }
    
}

// MARK: - CPAnimatorProtocol
extension CPSlideAnimator {
    
    public func performShowAnimation(view: UIView, completion: @escaping () -> Void) {
        if shouldUseFadeAnimation {
            view.alpha = 0
            view.isHidden = false
        }
        
        translate(view: view)
        
        animate(
            animations: {
                view.transform = .identity
                
                if shouldUseFadeAnimation {
                    view.alpha = 1
                }
            },
            completion: completion
        )
    }
    
    public func performHideAnimation(view: UIView, completion: @escaping () -> Void) {
        animate(
            animations: {
                translate(view: view)
                
                if shouldUseFadeAnimation {
                    view.alpha = 0
                }
            },
            completion: completion
        )
    }
    
}

// MARK: - Private methods
extension CPSlideAnimator {
    
    private func translate(view: UIView) {
        let transform: CGAffineTransform
        switch direction {
        case .up:
            let superviewHeight = view.superview?.frame.height ?? 0
            let translation = self.translation ?? superviewHeight - view.frame.origin.y
            transform = .init(translationX: 0, y: translation)
            
        case .down:
            let translation = self.translation ?? view.frame.height + view.frame.origin.y
            transform = .init(translationX: 0, y: -translation)
            
        case .left:
            let superviewWidth = view.superview?.frame.width ?? 0
            let translation = self.translation ?? superviewWidth - view.frame.origin.x
            transform = .init(translationX: translation, y: 0)
            
        case .right:
            let translation = self.translation ?? view.frame.width + view.frame.origin.x
            transform = .init(translationX: -translation, y: 0)
        }
        
        view.transform = transform
    }
    
    private func animate(animations: @escaping () -> Void, completion: @escaping () -> Void) {
        UIView.animate(
            withDuration: showDuration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: animations,
            completion: { isCompleted in
                guard isCompleted else { return }
                completion()
            }
        )
    }
    
}
