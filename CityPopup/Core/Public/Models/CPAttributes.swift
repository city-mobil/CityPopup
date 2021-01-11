//
//  CPAttributes.swift
//  CityPopup
//
//  Created by Чилимов Павел on 09.10.2020.
//

import UIKit

public struct CPAttributes {
    
    /**
     How long will it take to dismiss a popup. Default value is `nil`.
     - Important:
     Nil value means that a popup will not be dismissed automatically.
     */
    public let autodismissDelay: TimeInterval?
    /// Describes how to handle an interaction with background. Default value is `.dismiss`.
    public let backgroundInteractionHandling: InteractionHandling
    /// Setup anchors of a popup relative to it container's anchors. By default position is popup's center on container's center.
    public let position: Position
    /**
     Indentions of container. Default value is `.zero`.
     - Important:
     Nil value means that a safe area insets will not be considered.
     */
    public let margins: UIEdgeInsets?
    /// Priority of a popup display. Default value is `.medium`.
    public let priority: Priority
    /// Specify tags for identification.
    public let tags: [String]
    /**
     Indicates will be a popup fitted into its container or some part could be outside. Default value is `true`.
     - Important:
     Do not work with anchored points.
     */
    public let shouldFitToContainer: Bool
    
    /// - Parameters:
    ///   - autodismissDelay: How long will it take to dismiss a popup.
    ///   - backgroundInteractionHandling: Describes how to handle an interaction with background.
    ///   - position: Setup anchors of a popup relative to it container's anchors.
    ///   - margins: Indentions of container.
    ///   - priority: Priority of a popup display.
    ///   - tags: Specify tags for identification.
    ///   - shouldFitToContainer: Indicates will be a popup fitted into its container or some part could be outside.
    public init(
        autodismissDelay: TimeInterval? = nil,
        backgroundInteractionHandling: InteractionHandling = .dismiss,
        position: Position = .init(centerAnchorToAnchorPoint: .center),
        margins: UIEdgeInsets? = .zero,
        priority: Priority = .medium,
        tags: [String] = [],
        shouldFitToContainer: Bool = true)
    {
        self.autodismissDelay = autodismissDelay
        self.backgroundInteractionHandling = backgroundInteractionHandling
        self.position = position
        self.margins = margins
        self.priority = priority
        self.tags = tags
        self.shouldFitToContainer = shouldFitToContainer
    }
    
}
