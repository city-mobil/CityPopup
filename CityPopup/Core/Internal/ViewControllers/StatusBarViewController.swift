//
//  StatusBarViewController.swift
//  CityPopup
//
//  Created by Чилимов Павел on 21.12.2020.
//

import UIKit

final class StatusBarViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    private let statusBarStyle: UIStatusBarStyle
    
    init(statusBarStyle: UIStatusBarStyle) {
        self.statusBarStyle = statusBarStyle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
