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
    private var preferredStatusBarStyle: UIStatusBarStyle?
    private var window: UIWindow?
    private var backgroundViewData: BackgroundViewData?
    
    private let isOSUnder12Version = ProcessInfo().operatingSystemVersion.majorVersion < 12
    
    // MARK: - Init
    init(windowLevel: UIWindow.Level, preferredStatusBarStyle: UIStatusBarStyle?) {
        self.windowLevel = windowLevel
        self.preferredStatusBarStyle = preferredStatusBarStyle
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
            options: [.curveEaseInOut, .beginFromCurrentState],
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
        window.isHidden = true
        window.removeFromSuperview()
        self.window = nil
        
        // Fix web view display from popup on different window
        if isOSUnder12Version {
            UIApplication.shared.delegate?.window??.makeKeyAndVisible()
        }
    }
    
}

// MARK: - Private methods
extension ParentViewService {
    
    private func getWindow() -> UIWindow {
        if let currentWindow = self.window {
            return currentWindow
            
        } else {
            let newWindow = PassthroughWindow(frame: UIScreen.main.bounds)
            newWindow.windowLevel = windowLevel ?? .normal
            newWindow.isHidden = false
            newWindow.rootViewController = StatusBarViewController(statusBarStyle: preferredStatusBarStyle)
            self.window = newWindow
            
            // Fix web view display from popup on different window
            if isOSUnder12Version {
                newWindow.makeKeyAndVisible()
            }
            
            return newWindow
        }
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
