//
//  CPAlertActionStyle.swift
//  CityPopup
//
//  Created by Чилимов Павел on 05.11.2020.
//

import UIKit

public struct CPAlertActionStyle {
    
    // MARK: - Internal properties
    let height: CGFloat
    let cornerRadius: CGFloat
    let backgroundColor: UIColor
    
    let contentMargin: UIEdgeInsets
    let contentHorizontalSpacing: CGFloat
    
    let textFont: UIFont
    let textColor: UIColor
    let textAlignment: NSTextAlignment
    
    // MARK: - Init
    public init(
        height: CGFloat = 56,
        cornerRadius: CGFloat = 8,
        backgroundColor: UIColor = CPColor.gray4_gray20,
        contentMargin: UIEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16),
        contentHorizontalSpacing: CGFloat = 8,
        textFont: UIFont = .systemFont(ofSize: 18),
        textColor: UIColor = CPColor.black_white,
        textAlignment: NSTextAlignment = .center)
    {
        self.height = height
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.contentMargin = contentMargin
        self.contentHorizontalSpacing = contentHorizontalSpacing
        self.textFont = textFont
        self.textColor = textColor
        self.textAlignment = textAlignment
    }
    
}

// MARK: - Public predefined style
extension CPAlertActionStyle {
    
    public static let `default` = CPAlertActionStyle()
    
    public static let cancel = CPAlertActionStyle(backgroundColor: CPColor.orange, textColor: .white)
    
}
