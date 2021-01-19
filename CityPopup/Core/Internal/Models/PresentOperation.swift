//
//  PresentOperation.swift
//  CityPopup
//
//  Created by Чилимов Павел on 09.10.2020.
//

import UIKit

protocol PresentOperationDelegate: AnyObject {
    
    func presentOperationDidStart()
    func presentOperationWillComplete(operation: Operation)
    func presentOperationDidComplete(operation: Operation)
    
}

final class PresentOperation: Operation, PopupPresentationDelegate {
    
    // MARK: - Private types
    private enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    // MARK: - Internal properties
    let popupPresentationModel: PopupPresentationProtocol
    let parentView: UIView
    weak var delegate: PresentOperationDelegate?
    
    // MARK: - Private properties
    private let semaphore = DispatchSemaphore(value: 0)
    private var underlyingQueue: DispatchQueue?
    private var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    // MARK: - Init
    init(popupPresentationModel: PopupPresentationProtocol, parentView: UIView) {
        self.popupPresentationModel = popupPresentationModel
        self.parentView = parentView
    }
    
    // MARK: - Operation overrides
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override func start() {
        // Remember operation queue to freeze it on need safely
        underlyingQueue = OperationQueue.current?.underlyingQueue ?? DispatchQueue.global()
        
        guard !isCancelled else {
            state = .finished
            return
        }
        
        popupPresentationModel.delegate = self
        state = .executing
        
        main()
    }
    
    override func main() {
        delegate?.presentOperationDidStart()
        
        showPopupOnMainQueue { [weak self, weak underlyingQueue] in
            underlyingQueue?.async {
                self?.semaphore.signal()
            }
        }
        semaphore.wait()
        
        guard !isCancelled else { return }
        
        if let autodismissDelay: TimeInterval = popupPresentationModel.attributes.autodismissDelay {
            let _ = semaphore.wait(timeout: .now() + autodismissDelay)
            
            guard !isCancelled else { return }
            hidePopupOnMainQueue()
        }
    }
    
    override func cancel() {
        guard !isCancelled else { return }
        super.cancel()
        
        state = .finished
        // To make sure that the thread will be unlocked in the end to release memory,
        // cause the autodismiss logic freezes the thread with some timeout.
        semaphore.signal()
    }
    
}

// MARK: - Internal methods
extension PresentOperation {
    
    func hidePopup() {
        if let underlyingQueue = underlyingQueue {
            performPopupHiding(onQueue: underlyingQueue)
        } else {
            // Mark the operation as canceled
            super.cancel()
        }
    }
    
    func makeCopy() -> PresentOperation {
        let operation = PresentOperation(popupPresentationModel: popupPresentationModel, parentView: parentView)
        operation.queuePriority = queuePriority
        operation.delegate = delegate
        
        return operation
    }
    
}

// MARK: - Private methods
extension PresentOperation {
    
    private func showPopupOnMainQueue(completion: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.popupPresentationModel.show(
                on: self.parentView,
                completion: completion
            )
        }
    }
    
    private func performPopupHiding(onQueue queue: DispatchQueue) {
        queue.async { [weak self] in
            guard let self = self,
                  !self.isCancelled
            else {
                return
            }
            self.hidePopupOnMainQueue()
        }
    }
    
    private func hidePopupOnMainQueue() {
        DispatchQueue.main.async { [weak self] in
            self?.popupPresentationModel.hide()
        }
    }
    
}

// MARK: - PopupPresentationDelegate
extension PresentOperation {
    
    func hideAnimationWillPerformed() {
        underlyingQueue?.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.presentOperationWillComplete(operation: self)
        }
    }
    
    func hideAnimationDidPerformed() {
        underlyingQueue?.async { [weak self] in
            guard let self = self,
                  !self.isCancelled
            else {
                return
            }
            self.cancel()
            self.delegate?.presentOperationDidComplete(operation: self)
        }
    }
    
}
