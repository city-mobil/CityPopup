//
//  CPPopupViewProtocol.swift
//  CityPopup
//
//  Created by Георгий Сабанов on 09.10.2020.
//

import Foundation

public protocol CPPopupViewProtocol: CPViewWithLifecycleProtocol {}

// MARK: - Public extension
extension CPPopupViewProtocol {
    
    /// Hide the popup.
    /// - Parameter animator: Use specific animator for hide action.
    public func hide(usingAnimator animator: CPHideAnimatorProtocol? = nil) {
        onHide(animator)
    }
    
}

// MARK: - Internal extension
fileprivate var IdentifiableOnDismissKey = "kIdentifiableOnDismissKey"
extension CPPopupViewProtocol {
    
    var onHide: (CPHideAnimatorProtocol?) -> Void {
        get {
            let onHideClosure = objc_getAssociatedObject(self, &IdentifiableOnDismissKey) as? (CPHideAnimatorProtocol?) -> Void
            return onHideClosure ?? { _ in }
        }
        set {
            objc_setAssociatedObject(self, &IdentifiableOnDismissKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
