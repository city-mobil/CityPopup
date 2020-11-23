//
//  CityPopup.swift
//  CityPopup
//
//  Created by Георгий Сабанов on 18.09.2020.
//

import UIKit

public final class CityPopup: PresentationDispatchServiceDelegate {
    
    // MARK: - Public types
    public enum IntersectionRule {
        /// There are same elements
        case containing
        /// Elements are same
        case matching
    }
    
    // MARK: - Public properties
    public static let shared = CityPopup() ~> {
        $0.presentationDispatchService.setMaxConcurrentOperationCount(to: 1)
    }
    
    /// Get a popup which is showing.
    public var showingPopup: UIView? {
        let activeOperation = presentationDispatchService.operations(ofType: PresentOperation.self)
            .first { $0.isExecuting }
        return activeOperation?.popupPresentationModel.view
    }
    
    // MARK: - Private types
    private struct BackgroundViewData {
        let backgroundView: UIView
        let animationDuration: TimeInterval
    }
    
    // MARK: - Private properties
    private lazy var presentationDispatchService: PresentationDispatchServiceProtocol = PresentationDispatchService() ~> {
        $0.delegate = self
    }
    private var windows: [UIWindow.Level : UIWindow] = [:]
    private var backgroundViewData: BackgroundViewData?
    
}

// MARK: - Public methods
extension CityPopup {
    
    /// Show the view on a window.
    /// - Parameters:
    ///   - view: The view to show.
    ///   - animator: Animator which will animate view's motion.
    ///   - attributes: Attributes for the view.
    ///   - windowLevel: Popup display level. Default value is `.statusBar`.
    public func show(
        view: UIView,
        animator: CPAnimatorProtocol,
        attributes: CPAttributes,
        windowLevel: UIWindow.Level = .statusBar)
    {
        let window = visibleWindow(at: windowLevel)
        show(view: view, onView: window, animator: animator, attributes: attributes)
    }
    
    /// Show the popup view on a window.
    /// - Parameters:
    ///   - view: The popup view to show.
    ///   - animator: Animator which will animate view's motion.
    ///   - attributes: Attributes for the view.
    ///   - windowLevel: Popup display level. Default value is `.statusBar`.
    public func show(
        // TODO: - (p.chilimov) view -> popup
        view: CPPopupViewProtocol,
        animator: CPAnimatorProtocol,
        attributes: CPAttributes,
        windowLevel: UIWindow.Level = .statusBar)
    {
        show(view: view as UIView, animator: animator, attributes: attributes, windowLevel: windowLevel)
    }
    
    /// Show the view on the view controller.
    /// - Parameters:
    ///   - view: The view to show.
    ///   - parentViewController: The view controller on which the view will be shown.
    ///   - animator: Animator which will animate view's motion.
    ///   - attributes: Attributes for the view.
    public func show(
        view: UIView,
        onViewController parentViewController: UIViewController,
        animator: CPAnimatorProtocol,
        attributes: CPAttributes)
    {
        set(backgroundView: backgroundViewData?.backgroundView, onMainView: parentViewController.view)
        show(view: view, onView: parentViewController.view, animator: animator, attributes: attributes)
    }
    
    /// Show the view on the popup view controller.
    /// - Parameters:
    ///   - view: The popup view to show.
    ///   - parentViewController: The view controller on which the view will be shown.
    ///   - animator: Animator which will animate view's motion.
    ///   - attributes: Attributes for the view.
    public func show(
        view: CPPopupViewProtocol,
        onViewController parentViewController: UIViewController,
        animator: CPAnimatorProtocol,
        attributes: CPAttributes)
    {
        show(view: view as UIView, onViewController: parentViewController, animator: animator, attributes: attributes)
    }
    
    /// Setup background view for popups queue which uses only for decoration.
    /// - Parameters:
    ///   - backgroundView: Some view you wanted to see as a background. There is no background view by default.
    ///   - animationDuration: Duration of appearing and disappearing animations.
    /// - Important:
    /// The lib controls next background view's components: `alpha`, `isUserInteractionEnabled`, `translatesAutoresizingMaskIntoConstraints`
    public func setup(backgroundView: UIView, animationDuration: TimeInterval = 0.3) {
        backgroundView.alpha = 0
        backgroundView.isUserInteractionEnabled = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundViewData = .init(backgroundView: backgroundView, animationDuration: animationDuration)
    }
    
    /// Hide popups by specified tags.
    /// - Parameter tags: Tags in required popups.
    /// - Parameter rule: Rule for determining intersection method. Default value is `.containing`.
    public func hide(byTags tags: [String], rule: IntersectionRule = .containing) {
        guard !tags.isEmpty else {
            assertionFailure("Tags can not be empty")
            return
        }
        
        getOperations(byTags: tags, rule: rule)
            .forEach { operation in
                operation.popupPresentationModel.hide()
            }
    }
    
    /// Hide popups which are contained specified tag.
    /// - Parameter tag: Tag in required popups.
    public func hide(byTag tag: String) {
        hide(byTags: [tag], rule: .containing)
    }
    
    /// Hide popups for each tags.
    /// - Parameter tags: Variadic tags in required popups.
    public func hide(byTags tags: String...) {
        tags.forEach { tag in
            hide(byTag: tag)
        }
    }
    
    /// Get popups by specified tags.
    /// - Parameters:
    ///   - tags: Tags in required popups.
    ///   - rule: Rule for determining intersection method. Default value is `.containing`.
    public func getPopups(byTags tags: [String], rule: IntersectionRule = .containing) -> [UIView] {
        guard !tags.isEmpty else {
            assertionFailure("Tags can not be empty")
            return []
        }
        
        return getOperations(byTags: tags, rule: rule).map { $0.popupPresentationModel.view }
    }
    
    /// Get popups which are contained specified tag.
    /// - Parameter tag: Tag in required popups.
    public func getPopups(byTag tag: String) -> [UIView] {
        return getPopups(byTags: [tag], rule: .containing)
    }
    
    /// Get popups for each tags.
    /// - Parameter tags: Variadic tags in required popups.
    public func getPopups(byTags tags: String...) -> [UIView] {
        let flattanedPopups = Set(tags)
            .map { getPopups(byTag: $0) }
            .reduce([], +)
        var uniquePopups = Set<UIView>()
        
        flattanedPopups.forEach { popup in
            if !uniquePopups.contains(popup) {
                uniquePopups.insert(popup)
            }
        }
        
        return Array(uniquePopups)
    }
    
}

// MARK: - Private methods
extension CityPopup {
    
    private func show(
        view: UIView,
        onView parentView: UIView,
        animator: CPAnimatorProtocol,
        attributes: CPAttributes)
    {
        let presentation = PopupPresentation(
            view: view,
            animator: animator,
            attributes: attributes
        )
        let operation = PresentOperation(
            popupPresentationModel: presentation,
            parentView: parentView
        )
        presentationDispatchService.addToQueue(task: operation, priority: attributes.priority)
    }
    
    private func visibleWindow(at level: UIWindow.Level) -> UIWindow {
        let invisibleWindow = window(at: level)
        invisibleWindow.makeKeyAndVisible()
        return invisibleWindow
    }
    
    private func window(at level: UIWindow.Level) -> UIWindow {
        if let window = windows[level] {
            return window
        }
        
        return createNewWindow(withBackgroundView: backgroundViewData?.backgroundView, atLevel: level)
    }
    
    private func createNewWindow(withBackgroundView backgroundView: UIView?, atLevel level: UIWindow.Level) -> UIWindow {
        let window = PassthroughWindow(frame: UIScreen.main.bounds)
        window.windowLevel = level
        windows[level] = window
        
        set(backgroundView: backgroundView, onMainView: window)
        return window
    }
    
    private func set(backgroundView: UIView?, onMainView mainView: UIView) {
        guard let backgroundView = backgroundView else { return }
        
        mainView.addSubview(backgroundView)
        mainView.bringSubviewToFront(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: mainView.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
    }
    
    private func backgroundViewAnimate(shouldShow: Bool, completion: (() -> Void)? = nil) {
        guard let backgroundViewData = backgroundViewData else {
            completion?()
            return
        }
        UIView.animate(
            withDuration: backgroundViewData.animationDuration,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                backgroundViewData.backgroundView.alpha = shouldShow ? 1 : 0
            },
            completion: { _ in
                completion?()
            }
        )
    }
    
    private func getOperations(byTags tags: [String], rule: IntersectionRule) -> [PresentOperation] {
        guard !tags.isEmpty else {
            assertionFailure("Tags can not be empty")
            return []
        }
        
        return presentationDispatchService.operations(ofType: PresentOperation.self)
            .filter { operation in
                let operationsTags = operation.popupPresentationModel.attributes.tags
                
                switch rule {
                case .containing:
                    return Set(tags).isSubset(of: operationsTags)
                    
                case .matching:
                    return tags == operationsTags
                }
            }
    }
    
}

// MARK: - PresentationDispatchServiceDelegate
extension CityPopup {
    
    func presentationDispatchServiceDidStartOperation() {
        backgroundViewAnimate(shouldShow: true)
    }
    
    func presentationDispatchServiceDidComplete(operation: PresentOperation, areThereActiveOperations: Bool) {
        backgroundViewAnimate(shouldShow: false) { [weak self] in
            if !areThereActiveOperations {
                self?.backgroundViewData?.backgroundView.removeFromSuperview()
            }
            // Remove self created window
            if let index = self?.windows.firstIndex(where: { $0.value === operation.parentView }) {
                operation.parentView.removeFromSuperview()
                self?.windows.remove(at: index)
            }
        }
    }
    
}
