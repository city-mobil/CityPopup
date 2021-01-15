//
//  CPPopupView.swift
//  CityPopup
//
//  Created by Чилимов Павел on 14.01.2021.
//

import UIKit

public protocol CPPopupViewDelegate: AnyObject {
    
    func popupViewWillAppear(_ popupView: CPPopupView)
    func popupViewDidAppear(_ popupView: CPPopupView)
    func popupViewWillDisappear(_ popupView: CPPopupView)
    func popupViewDidDisappear(_ popupView: CPPopupView)
    
    func popupViewBackgroundTapPerformed()
    
}

public extension CPPopupViewDelegate {
    
    func popupViewWillAppear(_ popupView: CPPopupView) {}
    func popupViewDidAppear(_ popupView: CPPopupView) {}
    func popupViewWillDisappear(_ popupView: CPPopupView) {}
    func popupViewDidDisappear(_ popupView: CPPopupView) {}
    
    func popupViewBackgroundTapPerformed() {}
    
}

/// Base class for a popup. Inherit from it to be able to control some lifecycle and action methods.
open class CPPopupView: UIControl {
    
    // MARK: - Public properties
    public weak var delegate: CPPopupViewDelegate?
    
    // MARK: - Internal properties
    var onHide: ((CPHideAnimatorProtocol?) -> Void)?
    
    // MARK: - Open action methods
    /// Hide the popup.
    /// - Parameter animator: Use specific animator for hide action.
    open func hide(usingAnimator animator: CPHideAnimatorProtocol? = nil) {
        onHide?(animator)
    }
    
    open func backgroundTapPerformed() {
        delegate?.popupViewBackgroundTapPerformed()
    }
    
    // MARK: - Open lifecycle methods
    open func willAppear() {
        delegate?.popupViewWillAppear(self)
    }
    
    open func didAppear() {
        delegate?.popupViewDidAppear(self)
    }
    
    open func willDisappear() {
        delegate?.popupViewWillDisappear(self)
    }
    
    open func didDisappear() {
        delegate?.popupViewDidDisappear(self)
    }
    
}
