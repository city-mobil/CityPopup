//
//  CPColor.swift
//  CityPopup
//
//  Created by Чилимов Павел on 05.11.2020.
//

import UIKit

public enum CPColor {
    
    public static var white_black: UIColor {
        return .dynamicColor(light: .white, dark: .black)
    }
    
    public static var white_gray14: UIColor {
        return .dynamicColor(light: #colorLiteral(red: 0.999904573, green: 1, blue: 0.9998808503, alpha: 1), dark: #colorLiteral(red: 0.1372808516, green: 0.1372029781, blue: 0.1415385008, alpha: 1))
    }
    
    public static var gray4_gray20: UIColor {
        return .dynamicColor(light: #colorLiteral(red: 0.9607416987, green: 0.9607767463, blue: 0.9649803042, alpha: 1), dark: #colorLiteral(red: 0.1960993707, green: 0.1960297823, blue: 0.2003567517, alpha: 1))
    }
    
    public static var black_white: UIColor {
        return .dynamicColor(light: .black, dark: .white)
    }
    
    public static var orange: UIColor {
        return #colorLiteral(red: 0.9986096025, green: 0.4491870403, blue: 0.002680882812, alpha: 1)
    }
    
}
