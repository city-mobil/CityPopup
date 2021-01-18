//
//  DispatchService.swift
//  CityPopup
//
//  Created by Георгий Сабанов on 25.09.2020.
//

import Foundation

protocol DispatchServiceProtocol: AnyObject {
    
    /// Add an operation to the operation queue.
    /// - Parameters:
    ///   - task: Operation to process.
    ///   - priority: Operation priority in the queue.
    func addToQueue(task: Operation, priority: Operation.QueuePriority)
    
    /// Set maximum concurrent operations count. If new value is greater than the old value, then additional popups will show. If new value is lesser than the old value by N, then first N presented popups will be dismissed.
    /// - Parameter maxConcurrentOperationCount: Maximum concurrent operations count
    func setMaxConcurrentOperationCount(to maxConcurrentOperationCount: Int)
    
    /// Get operations on queue by type
    /// - Parameter ofType: Type of operations, must be inherited from Operation
    func operations<T: Operation>(ofType: T.Type) -> [T]
    
}

class DispatchService: DispatchServiceProtocol {
    
    // MARK: - Private properties
    private let operationQueue: OperationQueue
    
    // MARK: - Init
    init() {
        operationQueue = OperationQueue()
        operationQueue.underlyingQueue = DispatchQueue.global(qos: .userInteractive)
    }
    
}

// MARK: - DispatchServiceProtocol
extension DispatchService {
    
    func addToQueue(task: Operation, priority: Operation.QueuePriority) {
        task.queuePriority = priority
        operationQueue.addOperation(task)
    }
    
    func setMaxConcurrentOperationCount(to maxConcurrentOperationCount: Int) {
        operationQueue.maxConcurrentOperationCount = maxConcurrentOperationCount
    }
    
    func operations<T: Operation>(ofType: T.Type) -> [T] {
        return operationQueue.operations.compactMap { $0 as? T }
    }
    
}
