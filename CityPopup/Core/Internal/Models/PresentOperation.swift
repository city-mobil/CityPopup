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
    private(set) var semaphore = DispatchSemaphore(value: 0)
    
    // MARK: - Private properties
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
        
        semaphore = DispatchSemaphore(value: 0)
        let underlyingQueue = OperationQueue.current?.underlyingQueue
        showPopupOnMainQueue { [weak self, weak underlyingQueue] in
            underlyingQueue?.async {
                self?.semaphore.signal()
            }
        }
        semaphore.wait()
        
        guard !isCancelled else {
            hidePopupOnMainQueue()
            return
        }
        
        semaphore = DispatchSemaphore(value: 0)
        if let autodismissDelay: TimeInterval = popupPresentationModel.attributes.autodismissDelay {
            _ = semaphore.wait(timeout: .now() + autodismissDelay)
            hidePopupOnMainQueue()
        } else {
            semaphore.wait()
        }
    }
    
    override func cancel() {
        guard !isCancelled else { return }
        super.cancel()
        
        semaphore.signal()
        state = .finished
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
    
    private func hidePopupOnMainQueue() {
        guard !isCancelled else { return }
        
        semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.main.async { [weak self] in
            self?.popupPresentationModel.hide()
        }
        semaphore.wait()
    }
    
}

// MARK: - PopupPresentationDelegate
extension PresentOperation {
    
    func hideAnimationWillPerformed() {
        delegate?.presentOperationWillComplete(operation: self)
    }
    
    func hideAnimationDidPerformed() {
        guard !isCancelled else { return }
        cancel()
        delegate?.presentOperationDidComplete(operation: self)
    }
    
}
