//
//  CPFlipAnimator.swift
//  CityPopup
//
//  Created by Чилимов Павел on 27.11.2020.
//

import UIKit

public struct CPFlipAnimator: CPAnimatorProtocol {
    
    // MARK: - Private properties
    private let direction: CPDirection
    private let showDuration: TimeInterval
    private let hideDuration: TimeInterval
    private let isHideAnimationDirectionInverted: Bool
    
    // MARK: - Init
    public init(
        direction: CPDirection = .up,
        showDuration: TimeInterval = 0.3,
        hideDuration: TimeInterval = 0.3,
        isHideAnimationDirectionInverted: Bool = true)
    {
        self.direction = direction
        self.showDuration = showDuration
        self.hideDuration = hideDuration
        self.isHideAnimationDirectionInverted = isHideAnimationDirectionInverted
    }
    
}

// MARK: - CPAnimatorProtocol
extension CPFlipAnimator {
    
    public func performShowAnimation(view: UIView, completion: @escaping () -> Void) {
        UIView.transition(
            with: view,
            duration: showDuration,
            options: [transitionFlipOption()],
            animations: {
                view.isHidden = false
            },
            completion: { _ in
                completion()
            }
        )
    }
    
    public func performHideAnimation(view: UIView, completion: @escaping () -> Void) {
        let transitionOption = transitionFlipOption(isHideAnimationDirectionInverted: isHideAnimationDirectionInverted)
        UIView.transition(
            from: view,
            to: UIView(),
            duration: hideDuration,
            options: [transitionOption, .showHideTransitionViews],
            completion: { _ in
                completion()
            }
        )
    }
    
}

// MARK: - Private methods
extension CPFlipAnimator {
    
    private func transitionFlipOption(isHideAnimationDirectionInverted: Bool = false) -> UIView.AnimationOptions {
        let direction = isHideAnimationDirectionInverted ? self.direction.inverted : self.direction
        
        switch direction {
        case .down:
            return .transitionFlipFromTop
            
        case .left:
            return .transitionFlipFromRight
            
        case .right:
            return .transitionFlipFromLeft
            
        case .up:
            return .transitionFlipFromBottom
        }
    }
    
}
