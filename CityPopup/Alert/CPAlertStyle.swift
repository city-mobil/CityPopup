//
//  CPAlertStyle.swift
//  CityPopup
//
//  Created by Чилимов Павел on 03.11.2020.
//

import UIKit

public struct CPAlertStyle {
    
    // MARK: - Public types
    public enum ActionsAxis {
        /// Actions will be align vertically.
        case vertical
        /// Actions will be align horizontally and can be fit into container or can be scrollable.
        case horizontal(shouldFitIntoContainer: Bool)
    }
    
    // MARK: - Internal properties
    let cornerRadius: CGFloat
    let backgroundColor: UIColor
    
    let contentMargin: UIEdgeInsets
    
    let coverViewHeight: CGFloat?
    
    let titleFont: UIFont
    let titleColor: UIColor
    let titleTextAlignment: NSTextAlignment
    let titleNumberOfLines: Int
    
    let messageFont: UIFont
    let messageColor: UIColor
    let messageTextAligment: NSTextAlignment
    let messageNumberOfLines: Int
    
    let actionsAxis: ActionsAxis
    
    let spacingAfterCoverView: CGFloat
    let spacingAfterTitle: CGFloat
    let spacingAfterMessage: CGFloat
    let spacingBetweenActions: CGFloat
    
    // MARK: - Init
    public init(
        cornerRadius: CGFloat = 8,
        backgroundColor: UIColor = CPColor.white_gray14,
        contentMargin: UIEdgeInsets = .init(top: 24, left: 24, bottom: 24, right: 24),
        coverViewHeight: CGFloat? = nil,
        titleFont: UIFont = .boldSystemFont(ofSize: 24),
        titleColor: UIColor = CPColor.black_white,
        titleTextAlignment: NSTextAlignment = .center,
        titleNumberOfLines: Int = 0,
        messageFont: UIFont = .systemFont(ofSize: 16),
        messageColor: UIColor = CPColor.black_white,
        messageTextAligment: NSTextAlignment = .center,
        messageNumberOfLines: Int = 0,
        actionsAxis: ActionsAxis = .vertical,
        spacingAfterCoverView: CGFloat = 24,
        spacingAfterTitle: CGFloat = 24,
        spacingAfterMessage: CGFloat = 24,
        spacingBetweenActions: CGFloat = 16)
    {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.contentMargin = contentMargin
        self.coverViewHeight = coverViewHeight
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.titleTextAlignment = titleTextAlignment
        self.titleNumberOfLines = titleNumberOfLines
        self.messageFont = messageFont
        self.messageColor = messageColor
        self.messageTextAligment = messageTextAligment
        self.messageNumberOfLines = messageNumberOfLines
        self.actionsAxis = actionsAxis
        self.spacingAfterCoverView = spacingAfterCoverView
        self.spacingAfterTitle = spacingAfterTitle
        self.spacingAfterMessage = spacingAfterMessage
        self.spacingBetweenActions = spacingBetweenActions
    }
    
}

// MARK: - Public predefined style
extension CPAlertStyle {
    
    public static let `default` = CPAlertStyle()
    
}

// MARK: - Internal ActionsAxis extension
extension CPAlertStyle.ActionsAxis {
    
    var axis: NSLayoutConstraint.Axis {
        switch self {
        case .horizontal:
            return .horizontal
            
        case .vertical:
            return .vertical
        }
    }
    
}
