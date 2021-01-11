//
//  SwipeableScrollView.swift
//  CityPopup
//
//  Created by Чилимов Павел on 26.11.2020.
//

import UIKit

final class SwipeableScrollView: UIScrollView {
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        switch view {
        case is UIControl:
            return true
            
        default:
            return touchesShouldCancel(in: view)
        }
    }
    
}
