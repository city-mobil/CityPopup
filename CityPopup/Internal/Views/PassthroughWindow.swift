//
//  PassthroughWindow.swift
//  CityPopup
//
//  Created by Чилимов Павел on 09.10.2020.
//

import UIKit

final class PassthroughWindow: UIWindow {
    
    var shouldPassthrough: Bool = true
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view === self && shouldPassthrough {
            return nil
        }
        return view
    }
    
}
