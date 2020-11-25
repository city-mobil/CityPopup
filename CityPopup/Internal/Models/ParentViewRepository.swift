//
//  ParentViewRepository.swift
//  CityPopup
//
//  Created by Чилимов Павел on 25.11.2020.
//

import UIKit

/// Repository that will keep weak link on the view or create a window at the level.
final class ParentViewRepository {
    
    // MARK: - Public properties
    /// Get parent view. If there are no user's view then a window will be created and made key and visible.
    public var parentView: UIView {
        return view ?? getWindow()
    }
    
    // MARK: - Private properties
    private weak var view: UIView?
    private var windowLevel: UIWindow.Level?
    private var window: UIWindow?
    
    // MARK: - Init
    init(windowLevel: UIWindow.Level) {
        self.windowLevel = windowLevel
    }
    
    init(view: UIView) {
        self.view = view
    }
    
}

// MARK: - Internal methods
extension ParentViewRepository {
    
    func removeCreatedWindow() {
        guard let window = window else { return }
        window.removeFromSuperview()
        self.window = nil
    }
    
}

// MARK: - Private methods
extension ParentViewRepository {
    
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
    
}
