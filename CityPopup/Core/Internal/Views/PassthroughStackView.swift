//
//  PassthroughStackView.swift
//  CityPopup
//
//  Created by Чилимов Павел on 13.11.2020.
//

import UIKit

final class PassthroughStackView: UIStackView {
    
    var shouldPassthrough: Bool = true
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view === self && shouldPassthrough {
            return nil
        }
        return view
    }
    
}
