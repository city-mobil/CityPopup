//
//  AppDelegate.swift
//  CityPopupExamples
//
//  Created by Чилимов Павел on 23.11.2020.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        let tabBarController = UITabBarController()
        
        let alertsViewController = AlertsViewController()
        alertsViewController.tabBarItem = UITabBarItem(title: "Alerts", image: nil, selectedImage: nil)
        
        let toastsViewController = ToastsViewController()
        toastsViewController.tabBarItem = UITabBarItem(title: "Toasts", image: nil, selectedImage: nil)

        tabBarController.viewControllers = [alertsViewController, toastsViewController]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
    
}
