//
//  CPFadeAnimator.swift
//  CityPopup
//
//  Created by Чилимов Павел on 09.10.2020.
//

import UIKit

public struct CPFadeAnimator: CPAnimatorProtocol {
    
    // MARK: - Private properties
    private let showDuration: TimeInterval
    private let hideDuration: TimeInterval
    
    // MARK: - Init
    public init(
        showDuration: TimeInterval = 0.3,
        hideDuration: TimeInterval = 0.3)
    {
        self.showDuration = showDuration
        self.hideDuration = hideDuration
    }
    
}

// MARK: - PopupAnimationProtocol
extension CPFadeAnimator {
    
    public func performShowAnimation(view: UIView, completion: @escaping () -> Void) {
        view.isHidden = false
        view.alpha = 0
        
        UIView.animate(withDuration: showDuration) {
            view.alpha = 1
        } completion: { isCompleted in
            guard isCompleted else { return }
            completion()
        }
    }
    
    public func performHideAnimation(view: UIView, completion: @escaping () -> Void) {
        UIView.animate(withDuration: hideDuration) {
            view.alpha = 0
        } completion: { _ in
            completion()
        }
    }
    
}
