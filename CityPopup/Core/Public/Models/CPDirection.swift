//
//  CPDirection.swift
//  CityPopup
//
//  Created by Чилимов Павел on 17.11.2020.
//

public enum CPDirection {
    
    case left, up, right, down
    
    public var isAlongVertical: Bool {
        switch self {
        case .down, .up:
            return true
            
        case .left, .right:
            return false
        }
    }
    
    public var inverted: CPDirection {
        switch self {
        case .down:
            return .up
            
        case .left:
            return .right
            
        case .right:
            return .left
            
        case .up:
            return .down
        }
    }
    
}
