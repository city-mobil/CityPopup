//
//  PassthroughView.swift
//  CityPopup
//
//  Created by Чилимов Павел on 09.10.2020.
//

import UIKit

final class PassthroughView: UIView {
    
    var shouldPassthrough: Bool = true
    var backgroundTapDetected: (() -> Void)?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view === self && shouldPassthrough {
            return nil
        }
        return view
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if !shouldPassthrough,
           let touchPosition = touches.first?.location(in: self),
           hitTest(touchPosition, with: event) === self
        {
            backgroundTapDetected?()
        }
    }
    
}
