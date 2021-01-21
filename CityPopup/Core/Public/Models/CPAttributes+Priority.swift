//
//  CPAttributes+Priority.swift
//  CityPopup
//
//  Created by Георгий Сабанов on 25.09.2020.
//

import Foundation

extension CPAttributes {
    
    public enum Priority {
        
        /// Priority for low-level operations.
        case low
        /// Priority for medium-level operations.
        case medium
        /// Priority for high-level operations.
        case high
        /**
         Priority for required-level operations.
         Specify `shouldDelayExecutingOperations` to delay or not executing operations with lower priority.
         If it is `true` then executing operations with lower priority will be finished and move to the queue again, otherwise they will be finished and removed.
         If there are already operations with required priority then new one will be placed after them (FIFO).
         Default value is `false`.
         - Important:
         If you use own popup view, make sure that view has no memorable state or it should be reset on `didDisappear` event.
         E.g. when a popup becomes red when it appears (after show animation) you should reset this state to make sure that when the popup will be delayed it appear again correctly.
         */
        case required(shouldDelayExecutingOperations: Bool = false)
        
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
