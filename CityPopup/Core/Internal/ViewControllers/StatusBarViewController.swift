//
//  StatusBarViewController.swift
//  CityPopup
//
//  Created by Чилимов Павел on 21.12.2020.
//

import UIKit

final class StatusBarViewController: UIViewController {
    
    // MARK: - Private properties
    private let statusBarStyle: UIStatusBarStyle?
    
    private var statusBarStyleBasedOnMode: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .unspecified:
                return .default
                
            case .light:
                return .darkContent
                
            case .dark:
                return .lightContent
                
            @unknown default:
                return .default
            }
            
        } else {
            return .default
        }
    }
    
    // MARK: - Overrides
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle ?? statusBarStyleBasedOnMode
    }
    
    // MARK: - Init
    init(statusBarStyle: UIStatusBarStyle?) {
        self.statusBarStyle = statusBarStyle
        super.init(nibName: nil, bundle: nil)
        view.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
