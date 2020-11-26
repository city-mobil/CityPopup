//
//  PresentOperation.swift
//  CityPopup
//
//  Created by Чилимов Павел on 09.10.2020.
//

import UIKit

protocol PresentOperationDelegate: AnyObject {
    
    func presentOperationDidStart()
    func presentOperationDidComplete(operation: Operation)
    
}

final class PresentOperation: Operation {
    
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
        state = .executing
        main()
    }
    
    override func main() {
        delegate?.presentOperationDidStart()
        showPopupOnMainQueue()
        
        guard !isCancelled else {
            hidePopupOnMainQueue()
            return
        }
        
        semaphore = DispatchSemaphore(value: 0)
        popupPresentationModel.onClose = { [weak self] in
            guard let self = self, !self.isCancelled else { return }
            self.cancel()
            self.delegate?.presentOperationDidComplete(operation: self)
        }
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
    
    private func showPopupOnMainQueue() {
        semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.main.async {
            // TODO: - Здесь похоже течем, если self будет виком, то попап не удалится
            self.popupPresentationModel.show(
                on: self.parentView,
                completion: { [weak self] in
                    DispatchQueue.global().async {
                        guard let self = self, !self.isCancelled else { return }
                        self.semaphore.signal()
                    }
                }
            )
        }
        semaphore.wait()
    }
    
    private func hidePopupOnMainQueue() {
        guard !isCancelled else {
            DispatchQueue.main.async {
                // TODO: - Здесь похоже течем, если self будет виком, то попап не удалится
                self.popupPresentationModel.close()
            }
            return
        }
        semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.main.async {
            self.popupPresentationModel.hide()
        }
        semaphore.wait()
    }
    
}
