//
//  ParentViewService.swift
//  CityPopup
//
//  Created by Чилимов Павел on 25.11.2020.
//

import UIKit

/// Service that will keep weak link on the view or create a window at the level.
/// It also manage some operations over the parent view.
final class ParentViewService {
    
    // MARK: - Private types
    private struct BackgroundViewData {
        let backgroundView: UIView
        let animationDuration: TimeInterval
        var isUsing = false
    }
    
    // MARK: - Private properties
    private weak var view: UIView?
    private var windowLevel: UIWindow.Level?
    private var window: UIWindow?
    private var backgroundViewData: BackgroundViewData?
    
    // MARK: - Init
    init(windowLevel: UIWindow.Level) {
        self.windowLevel = windowLevel
    }
    
    init(view: UIView) {
        self.view = view
    }
    
}

// MARK: - Internal methods
extension ParentViewService {
    
    /// Get parent view. If there are no user's view then a window will be created and made key and visible.
    /// - Important:
    /// Layout of the background will be called here, cause now parent view definitely exists.
    func getParentView() -> UIView {
        let parentView = view ?? getWindow()
        layoutBackgroundView(onView: parentView)
        return parentView
    }
    
    func setup(backgroundView: UIView, animationDuration: TimeInterval) {
        backgroundView.alpha = 0
        backgroundView.isUserInteractionEnabled = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundViewData = .init(backgroundView: backgroundView, animationDuration: animationDuration)
    }
    
    func backgroundViewAnimate(shouldShow: Bool, completion: (() -> Void)? = nil) {
        guard let backgroundViewData = backgroundViewData else {
            completion?()
            return
        }
        UIView.animate(
            withDuration: backgroundViewData.animationDuration,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                backgroundViewData.backgroundView.alpha = shouldShow ? 1 : 0
            },
            completion: { _ in
                completion?()
            }
        )
    }
    
    func stopUsingBackground() {
        backgroundViewData?.backgroundView.removeFromSuperview()
        backgroundViewData?.isUsing = false
    }
    
    func removeCreatedWindow() {
        guard let window = window else { return }
        window.removeFromSuperview()
        self.window = nil
    }
    
}

// MARK: - Private methods
extension ParentViewService {
    
    private func getWindow() -> UIWindow {
        if let currentWindow = self.window {
            return currentWindow
            
        } else {
            let newWindow = createWindow(atLevel: windowLevel ?? .normal)
            newWindow.makeKeyAndVisible()
            self.window = newWindow
            return newWindow
        }
    }
    
    private func createWindow(atLevel level: UIWindow.Level) -> UIWindow {
        let window = PassthroughWindow(frame: UIScreen.main.bounds)
        window.windowLevel = level
        return window
    }
    
    private func layoutBackgroundView(onView view: UIView) {
        guard let backgroundView = backgroundViewData?.backgroundView,
              backgroundViewData?.isUsing == false
        else {
            return
        }
        
        self.backgroundViewData?.isUsing = true
        
        view.addSubview(backgroundView)
        view.bringSubviewToFront(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}
