//
//  CPToastStyle.swift
//  CityPopup
//
//  Created by Чилимов Павел on 12.11.2020.
//

import UIKit

public struct CPToastStyle {
    
    // MARK: - Internal properties
    let cornerRadius: CGFloat
    let backgroundColor: UIColor
    
    let contentMargin: UIEdgeInsets
    
    let titleFont: UIFont
    let titleTextAlignment: NSTextAlignment
    let titleNumberOfLines: Int
    let titleTextColor: UIColor

    let messageFont: UIFont
    let messageTextAligment: NSTextAlignment
    let messageNumberOfLines: Int
    let messageTextColor: UIColor

    let horizontalSpacingAfterLeadingContainer: CGFloat
    let verticalSpacingAfterTitle: CGFloat
    let horizontalSpacingAfterTitle: CGFloat
    
    // MARK: - Init
    public init(
        cornerRadius: CGFloat = 8,
        backgroundColor: UIColor = CPColor.white_gray14,
        contentMargin: UIEdgeInsets = .init(top: 24, left: 24, bottom: 24, right: 24),
        titleFont: UIFont = .systemFont(ofSize: 18),
        titleTextAlignment: NSTextAlignment = .center,
        titleNumberOfLines: Int = 0,
        titleTextColor: UIColor = CPColor.black_white,
        messageFont: UIFont = .systemFont(ofSize: 14),
        messageTextAligment: NSTextAlignment = .center,
        messageNumberOfLines: Int = 0,
        messageTextColor: UIColor = CPColor.black_white,
        horizontalSpacingAfterLeadingContainer: CGFloat = 8,
        verticalSpacingAfterTitle: CGFloat = 8,
        horizontalSpacingAfterTitle: CGFloat = 8)
    {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.contentMargin = contentMargin
        self.titleFont = titleFont
        self.titleTextAlignment = titleTextAlignment
        self.titleNumberOfLines = titleNumberOfLines
        self.titleTextColor = titleTextColor
        self.messageFont = messageFont
        self.messageTextAligment = messageTextAligment
        self.messageNumberOfLines = messageNumberOfLines
        self.messageTextColor = messageTextColor
        self.horizontalSpacingAfterLeadingContainer = horizontalSpacingAfterLeadingContainer
        self.verticalSpacingAfterTitle = verticalSpacingAfterTitle
        self.horizontalSpacingAfterTitle = horizontalSpacingAfterTitle
    }
    
}

// MARK: - Public predefined style
extension CPToastStyle {
    
    public static let `default` = CPToastStyle()
    
}
