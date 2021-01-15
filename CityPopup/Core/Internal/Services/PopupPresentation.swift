//
//  PopupPresentation.swift
//  CityPopup
//
//  Created by Георгий Сабанов on 18.09.2020.
//

import UIKit

protocol PopupPresentationProtocol: AnyObject {
    
    var view: UIView { get }
    var animator: CPAnimatorProtocol { get }
    var attributes: CPAttributes { get }
    var delegate: PopupPresentationDelegate? { get set }
    
    func show(on parent: UIView, completion: @escaping () -> Void)
    func hide(completion: (() -> Void)?)
    func close()
    
}

extension PopupPresentationProtocol {
    
    func hide(completion: (() -> Void)? = nil) {
        hide(completion: completion)
    }
    
}

protocol PopupPresentationDelegate: AnyObject {
    
    func hideAnimationWillPerformed()
    func hideAnimationDidPerformed()
    
}

final class PopupPresentation: PopupPresentationProtocol {
    
    // MARK: - PopupPresentationProtocol
    let view: UIView
    let animator: CPAnimatorProtocol
    let attributes: CPAttributes
    weak var delegate: PopupPresentationDelegate?
    
    // MARK: - Private properties
    private let container = PassthroughView() ~> {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private var popupView: CPPopupView? {
        return view as? CPPopupView
    }
    private var isHiding = false
    
    // MARK: - Init
    init(
        view: UIView,
        animator: CPAnimatorProtocol,
        attributes: CPAttributes)
    {
        self.view = view
        self.animator = animator
        self.attributes = attributes
        
        setupContainer(interactionHandling: attributes.backgroundInteractionHandling)
        popupView?.onHide = { [weak self] animator in
            self?.hide(animator: animator)
        }
    }
    
}

// MARK: - PopupPresentationProtocol
extension PopupPresentation {
    
    func show(on parent: UIView, completion: @escaping () -> Void) {
        setupContainerLayout(on: parent, margins: attributes.margins)
        putIntoContainer(
            view,
            shouldConsiderLayoutGuide: attributes.margins != nil,
            shouldFitToContainer: attributes.shouldFitToContainer
        )
        
        popupView?.willAppear()
        container.layoutIfNeeded()
        
        animator.performShowAnimation(view: view) { [weak self] in
            self?.popupView?.didAppear()
            completion()
        }
    }
    
    func hide(completion: (() -> Void)? = nil) {
        hide(animator: nil, completion: completion)
    }
    
    func close() {
        container.removeFromSuperview()
        delegate?.hideAnimationDidPerformed()
    }
    
}

// MARK: - Private methods
extension PopupPresentation {
    
    private func setupContainer(interactionHandling: CPAttributes.InteractionHandling) {
        switch interactionHandling {
        case .dismiss:
            container.shouldPassthrough = false
            container.backgroundTapDetected = { [weak self] in
                self?.popupView?.backgroundTapPerformed()
                self?.hide()
            }
            
        case .passthrough(let shouldPassthrough):
            container.shouldPassthrough = shouldPassthrough
        }
    }
    
    private func putIntoContainer(_ view: UIView, shouldConsiderLayoutGuide: Bool, shouldFitToContainer: Bool) {
        guard !container.subviews.contains(view), view.superview == nil else { return }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        container.addSubview(view)
        
        if shouldFitToContainer {
            fitToContainer(view: view, shouldConsiderLayoutGuide: shouldConsiderLayoutGuide)
        }
        attributes.position.anchors
            .forEach { anchor in
                view.set(anchor: anchor, toView: container, shouldConsiderLayoutGuide: shouldConsiderLayoutGuide)
            }
    }
    
    private func setupContainerLayout(on parent: UIView, margins: UIEdgeInsets?) {
        if let margins = margins {
            if #available(iOS 11.0, *) {
                container.directionalLayoutMargins = .init(
                    top: margins.top,
                    leading: margins.left,
                    bottom: margins.bottom,
                    trailing: margins.right
                )
            } else {
                container.layoutMargins = margins
            }
        }
        
        parent.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            container.topAnchor.constraint(equalTo: parent.topAnchor),
            container.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
        ])
    }
    
    private func fitToContainer(view: UIView, shouldConsiderLayoutGuide: Bool) {
        let toItem = shouldConsiderLayoutGuide ? container.layoutMarginsGuide : container
        
        let leadingConstraint = NSLayoutConstraint(
            item: view,
            attribute: .leading,
            relatedBy: .greaterThanOrEqual,
            toItem: toItem,
            attribute: .leading,
            multiplier: 1,
            constant: 0
        )
        let topConstraint = NSLayoutConstraint(
            item: view,
            attribute: .top,
            relatedBy: .greaterThanOrEqual,
            toItem: toItem,
            attribute: .top,
            multiplier: 1,
            constant: 0
        )
        let trailingConstraint = NSLayoutConstraint(
            item: view,
            attribute: .trailing,
            relatedBy: .lessThanOrEqual,
            toItem: toItem,
            attribute: .trailing,
            multiplier: 1,
            constant: 0
        )
        let bottomConstraint = NSLayoutConstraint(
            item: view,
            attribute: .bottom,
            relatedBy: .lessThanOrEqual,
            toItem: toItem,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        let constraints = [leadingConstraint, topConstraint, trailingConstraint, bottomConstraint]
        constraints.forEach { constraint in
            container.addConstraint(constraint)
            constraint.isActive = true
        }
    }
    
    private func hide(animator: CPHideAnimatorProtocol? = nil, completion: (() -> Void)? = nil) {
        guard !isHiding else { return }
        isHiding = true
        
        popupView?.willDisappear()
        
        let dismissAnimator = animator ?? self.animator
        
        delegate?.hideAnimationWillPerformed()
        dismissAnimator.performHideAnimation(view: view) { [weak self] in
            self?.close()
            self?.popupView?.didDisappear()
            completion?()
        }
    }
    
}
