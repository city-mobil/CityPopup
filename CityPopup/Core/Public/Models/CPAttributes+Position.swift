//
//  CPAttributes+Position.swift
//  CityPopup
//
//  Created by Чилимов Павел on 13.10.2020.
//

extension CPAttributes {
    
    public enum AnchorPoint {
        
        case leftTop, centerTop, rightTop, leftCenter, center, rightCenter, leftBottom, centerBottom, rightBottom
        
    }
    public struct Anchor {
        
        public let mainAnchorPoint: AnchorPoint
        public let toAnchorPoint: AnchorPoint
        
        public init(mainAnchorPoint: CPAttributes.AnchorPoint, toAnchorPoint: CPAttributes.AnchorPoint) {
            self.mainAnchorPoint = mainAnchorPoint
            self.toAnchorPoint = toAnchorPoint
        }
        
        fileprivate init?(mainAnchorPoint: CPAttributes.AnchorPoint, toAnchorPoint: CPAttributes.AnchorPoint?) {
            guard let toAnchorPoint = toAnchorPoint else { return nil }
            self.mainAnchorPoint = mainAnchorPoint
            self.toAnchorPoint = toAnchorPoint
        }
        
    }
    
    public struct Position {
        
        // MARK: - Public properties
        public var leftTopAnchor: Anchor?
        public var centerTopAnchor: Anchor?
        public var rightTopAnchor: Anchor?
        public var leftCenterAnchor: Anchor?
        public var centerAnchor: Anchor?
        public var rightCenterAnchor: Anchor?
        public var leftBottomAnchor: Anchor?
        public var centerBottomAnchor: Anchor?
        public var rightBottomAnchor: Anchor?
        
        /// From left to right side top position
        public static var top: Position {
            return .init(leftTopAnchorToAnchorPoint: .leftTop, rightTopAnchorToAnchorPoint: .rightTop)
        }
        /// Center position
        public static var center: Position {
            return .init(centerAnchorToAnchorPoint: .center)
        }
        /// From left to right side bottom position
        public static var bottom: Position {
            return .init(leftBottomAnchorToAnchorPoint: .leftBottom, rightBottomAnchorToAnchorPoint: .rightBottom)
        }
        /// From left to right side, from top to bottom side
        public static var fill: Position {
            return .init(
                leftTopAnchorToAnchorPoint: .leftTop,
                rightTopAnchorToAnchorPoint: .rightTop,
                rightBottomAnchorToAnchorPoint: .rightBottom
            )
        }
        
        // MARK: - Internal properties
        var anchors: [Anchor] {
            return Mirror(reflecting: self).children.compactMap { $0.value as? Anchor }
        }
        
        // MARK: - Init
        public init(
            leftTopAnchorToAnchorPoint: CPAttributes.AnchorPoint? = nil,
            centerTopAnchorToAnchorPoint: CPAttributes.AnchorPoint? = nil,
            rightTopAnchorToAnchorPoint: CPAttributes.AnchorPoint? = nil,
            leftCenterAnchorToAnchorPoint: CPAttributes.AnchorPoint? = nil,
            centerAnchorToAnchorPoint: CPAttributes.AnchorPoint? = nil,
            rightCenterAnchorToAnchorPoint: CPAttributes.AnchorPoint? = nil,
            leftBottomAnchorToAnchorPoint: CPAttributes.AnchorPoint? = nil,
            centerBottomAnchorToAnchorPoint: CPAttributes.AnchorPoint? = nil,
            rightBottomAnchorToAnchorPoint: CPAttributes.AnchorPoint? = nil)
        {
            self.leftTopAnchor = Anchor(mainAnchorPoint: .leftTop, toAnchorPoint: leftTopAnchorToAnchorPoint)
            self.centerTopAnchor = Anchor(mainAnchorPoint: .centerTop, toAnchorPoint: centerTopAnchorToAnchorPoint)
            self.rightTopAnchor = Anchor(mainAnchorPoint: .rightTop, toAnchorPoint: rightTopAnchorToAnchorPoint)
            self.leftCenterAnchor = Anchor(mainAnchorPoint: .leftCenter, toAnchorPoint: leftCenterAnchorToAnchorPoint)
            self.centerAnchor = Anchor(mainAnchorPoint: .center, toAnchorPoint: centerAnchorToAnchorPoint)
            self.rightCenterAnchor = Anchor(mainAnchorPoint: .rightCenter, toAnchorPoint: rightCenterAnchorToAnchorPoint)
            self.leftBottomAnchor = Anchor(mainAnchorPoint: .leftBottom, toAnchorPoint: leftBottomAnchorToAnchorPoint)
            self.centerBottomAnchor = Anchor(mainAnchorPoint: .centerBottom, toAnchorPoint: centerBottomAnchorToAnchorPoint)
            self.rightBottomAnchor = Anchor(mainAnchorPoint: .rightBottom, toAnchorPoint: rightBottomAnchorToAnchorPoint)
        }
        
    }
    
}
