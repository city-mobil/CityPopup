//
//  PresentationDispatchService.swift
//  CityPopup
//
//  Created by Чилимов Павел on 02.11.2020.
//

import Foundation

protocol PresentationDispatchServiceProtocol: DispatchServiceProtocol {
    
    var delegate: PresentationDispatchServiceDelegate? { get set }
    
    /// Add a present operation to the presentation queue.
    /// - Parameters:
    ///   - task: PresentOperation with popup presentation implementation.
    ///   - priority: Operation priority in the queue.
    func addToQueue(task: PresentOperation, priority: CPAttributes.Priority)
    
}

protocol PresentationDispatchServiceDelegate: AnyObject {
    
    /// An operation did start by presentation dispatch service. Called on main queue.
    func presentationDispatchServiceDidStartOperation()
    
    /// The operation will complete by presentation dispatch service. Called on main queue.
    /// - Parameters:
    ///   - operation: The operation wich will be completed.
    ///   - areThereActiveOperations: Inicate are there any active present operation or not.
    func presentationDispatchServiceWillComplete(operation: PresentOperation, areThereActiveOperations: Bool)
    
    /// The operation did complete by presentation dispatch service. Called on main queue.
    /// - Parameters:
    ///   - operation: Completed operation.
    ///   - areThereActiveOperations: Inicate are there any active present operation or not.
    func presentationDispatchServiceDidComplete(operation: PresentOperation, areThereActiveOperations: Bool)
    
}

final class PresentationDispatchService: DispatchService, PresentationDispatchServiceProtocol, PresentOperationDelegate {
    
    weak var delegate: PresentationDispatchServiceDelegate?
    
}

// MARK: - PresentationDispatchServiceProtocol
extension PresentationDispatchService {
    
    func addToQueue(task: PresentOperation, priority: CPAttributes.Priority) {
        task.delegate = self
        super.addToQueue(task: task, priority: priority.operationQueuePriority)
        if priority == .required {
            hideNotRequiredActiveOperations()
        }
    }
    
}

// MARK: - PresentOperationDelegate
extension PresentationDispatchService {
    
    func presentOperationDidStart() {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.presentationDispatchServiceDidStartOperation()
        }
    }
    
    func presentOperationWillComplete(operation: Operation) {
        guard let presentOperation = operation as? PresentOperation else { return }
        
        let areThereActiveOperations = calculateAreThereActiveOperations(forPresentOperation: presentOperation)
        
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.presentationDispatchServiceWillComplete(
                operation: presentOperation,
                areThereActiveOperations: areThereActiveOperations
            )
        }
    }
    
    func presentOperationDidComplete(operation: Operation) {
        guard let presentOperation = operation as? PresentOperation else { return }
        
        let areThereActiveOperations = calculateAreThereActiveOperations(forPresentOperation: presentOperation)
        
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.presentationDispatchServiceDidComplete(
                operation: presentOperation,
                areThereActiveOperations: areThereActiveOperations
            )
        }
    }
    
}

// MARK: - Private methods
extension PresentationDispatchService {
    
    private func calculateAreThereActiveOperations(forPresentOperation presentOperation: PresentOperation) -> Bool {
        let activeOperations = operations(ofType: PresentOperation.self)
            .filter { $0 !== presentOperation }
        return !activeOperations.isEmpty
    }
    
    private func hideNotRequiredActiveOperations() {
        operations(ofType: PresentOperation.self)
            .filter { $0.isExecuting }
            .filter { $0.queuePriority != .veryHigh }
            .forEach { $0.hidePopup() }
    }
    
}
