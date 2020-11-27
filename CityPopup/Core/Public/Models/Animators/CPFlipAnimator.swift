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
    
    public init(
        direction: CPDirection = .up,
        showDuration: TimeInterval = 0.3,
        hideDuration: TimeInterval = 0.3)
    {
        self.direction = direction
        self.showDuration = showDuration
        self.hideDuration = hideDuration
    }
    
}

// MARK: - CPAnimatorProtocol
extension CPFlipAnimator {
    
    public func performShowAnimation(view: UIView, completion: @escaping () -> Void) {
        view.isHidden = true
        view.clipsToBounds = false


//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            UIView.transition(
                with: view,
                duration: showDuration,
                options: [.curveEaseInOut, .transitionFlipFromTop],
                animations: {
                    view.isHidden = false
                },
                completion: { _ in
                    completion()
                }
            )
//        }
    }
    
    public func performHideAnimation(view: UIView, completion: @escaping () -> Void) {
        completion()
    }
    
}

// MARK: - Private methods
extension CPFlipAnimator {
    
    private func translate(view: UIView) {
        let transform: CGAffineTransform
        switch direction {
        case .up:
            let superviewHeight = view.superview?.frame.height ?? 0
            let translation = superviewHeight - view.frame.origin.y
            transform = .init(translationX: 0, y: translation)
            
        case .down:
            let translation = view.frame.height + view.frame.origin.y
            transform = .init(translationX: 0, y: -translation)
            
        case .left:
            let superviewWidth = view.superview?.frame.width ?? 0
            let translation = superviewWidth - view.frame.origin.x
            transform = .init(translationX: translation, y: 0)
            
        case .right:
            let translation = view.frame.width + view.frame.origin.x
            transform = .init(translationX: -translation, y: 0)
        }
        
        view.transform = transform
    }
    
}
