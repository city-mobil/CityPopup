//
//  UIColor+colorAdjustment.swift
//  CityPopup
//
//  Created by Чилимов Павел on 06.11.2020.
//

import UIKit

extension UIColor {
    
    func darker(percentage: CGFloat = 5) -> UIColor {
        return adjustColor(percentage: -abs(percentage))
    }
    
    private func adjustColor(percentage: CGFloat) -> UIColor {
        var red: CGFloat = 0.0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return self }

        return UIColor(
            red: min(red + percentage / 100, 1),
            green: min(green + percentage / 100, 1),
            blue: min(blue + percentage / 100, 1),
            alpha: alpha
        )
    }
    
}
