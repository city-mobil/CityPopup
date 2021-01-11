//
//  CPAttributes+Priority.swift
//  CityPopup
//
//  Created by Георгий Сабанов on 25.09.2020.
//

import Foundation

extension CPAttributes {
    
    public enum Priority {
        
        case low
        case medium
        case high
        case required
        
    }
    
}

// MARK: - Internal properties
extension CPAttributes.Priority {
    
    var operationQueuePriority: Operation.QueuePriority {
        switch self {
        case .low:
            return .low
            
        case .medium:
            return .normal
            
        case .high:
            return.high
            
        case .required:
            return .veryHigh
        }
    }
    
}
