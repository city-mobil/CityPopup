//
//  UIColor+dynamicColor.swift
//  CityPopup
//
//  Created by Чилимов Павел on 05.11.2020.
//

import UIKit

extension UIColor {
    
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection -> UIColor in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return dark
                    
                case .unspecified, .light:
                    return light
                    
                @unknown default:
                    return light
                }
            }
            
        } else {
            return light
        }
    }
    
}
