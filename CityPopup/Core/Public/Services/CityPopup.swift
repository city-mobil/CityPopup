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
    /// Predefined instance which by default will be showing popup on a window at `.statusBar` level one by one.
    /// - Important:
    /// You can change maximum of concurrent operations count by `maxConcurrentOperationCount`.
    /// To show popup on different level or on a controller use one of the init functions.
    public static let shared = CityPopup()
    
    /// Maximum concurrent operations count.
    /// If new value is greater than the old value, then additional popups will show.
    /// If new value is lesser than the old value by N, then first N presented popups will be dismissed.
    public var maxConcurrentOperationCount: Int {
        didSet {
            presentationDispatchService.setMaxConcurrentOperationCount(to: maxConcurrentOperationCount)
        }
    }
    
    /// Get a popup which is showing.
    public var showingPopup: UIView? {
        let activeOperation = presentationDispatchService.operations(ofType: PresentOperation.self)
            .first { $0.isExecuting }
        return activeOperation?.popupPresentationModel.view
    }
    
    // MARK: - Private properties
    private let parentViewService: ParentViewService
    
    private lazy var presentationDispatchService: PresentationDispatchServiceProtocol = PresentationDispatchService() ~> {
        $0.delegate = self
    }
    
    // MARK: - Public init
    /// Use this init to show popups on a window at the `windowLevel`.
    /// - Parameters:
    ///   - windowLevel: Level of a window.
    ///   - maxConcurrentOperationCount: Maximum concurrent operations count.
    ///   - preferredStatusBarStyle: Set the status bar style otherwise it will depend on UI mode (dark/light).
    /// - Important:
    /// Do not forget save an instance address of CityPopup to not break some logic (i.e. background's logic will not work).
    public init(
        showOnLevel windowLevel: UIWindow.Level = .statusBar,
        maxConcurrentOperationCount: Int = 1,
        preferredStatusBarStyle: UIStatusBarStyle? = nil)
    {
        parentViewService = ParentViewService(windowLevel: windowLevel, preferredStatusBarStyle: preferredStatusBarStyle)
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
        commonInit(maxConcurrentOperationCount: maxConcurrentOperationCount)
    }
    
    /// Use this init to show popups on the view which will be keeped weakly.
    /// - Parameters:
    ///   - view: Some view on which popups will be shown.
    ///   - maxConcurrentOperationCount: Maximum concurrent operations count.
    /// - Important:
    /// Do not forget save an instance address of CityPopup to not break some logic (i.e. background's logic will not work).
    public init(showOnView view: UIView, maxConcurrentOperationCount: Int = 1) {
        parentViewService = ParentViewService(view: view)
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
        commonInit(maxConcurrentOperationCount: maxConcurrentOperationCount)
    }
    
    // MARK: - Private init
    private func commonInit(maxConcurrentOperationCount: Int) {
        presentationDispatchService.setMaxConcurrentOperationCount(to: maxConcurrentOperationCount)
    }
    
}

// MARK: - Public methods
extension CityPopup {
    
    /// Show the view.
    /// - Parameters:
    ///   - view: The view to show.
    ///   - animator: Animator which will animate view's motion.
    ///   - attributes: Attributes for the view.
    public func show(
        view: UIView,
        animator: CPAnimatorProtocol = CPFadeAnimator(),
        attributes: CPAttributes = .init())
    {
        let parentView = parentViewService.getParentView()
        show(view: view, onView: parentView, animator: animator, attributes: attributes)
    }
    
    /// Show the popup view.
    /// - Parameters:
    ///   - popup: The popup view to show.
    ///   - animator: Animator which will animate view's motion.
    ///   - attributes: Attributes for the view.
    public func show(
        popup: CPPopupView,
        animator: CPAnimatorProtocol = CPFadeAnimator(),
        attributes: CPAttributes = .init())
    {
        show(view: popup as UIView, animator: animator, attributes: attributes)
    }
    
    /// Setup background view for popups queue which uses only for decoration. There is no background view by default.
    /// - Parameters:
    ///   - backgroundView: Some view you wanted to see as a background.
    ///   - animationDuration: Duration of appearing and disappearing animations.
    /// - Important:
    /// The background view will be keeped strongly.
    /// The framework controls next background view's components: `alpha`, `isUserInteractionEnabled`, `translatesAutoresizingMaskIntoConstraints`.
    public func setup(backgroundView: UIView, animationDuration: TimeInterval = 0.3) {
        parentViewService.setup(backgroundView: backgroundView, animationDuration: animationDuration)
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
                operation.hidePopup()
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
    
    /// Hide all popups.
    public func hideAll() {
        getAllOperations().forEach { operation in
            operation.hidePopup()
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
    
    private func getOperations(byTags tags: [String], rule: IntersectionRule) -> [PresentOperation] {
        guard !tags.isEmpty else {
            assertionFailure("Tags can not be empty")
            return []
        }
        
        return getAllOperations()
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
    
    private func getAllOperations() -> [PresentOperation] {
        return presentationDispatchService.operations(ofType: PresentOperation.self)
    }
    
}

// MARK: - PresentationDispatchServiceDelegate
extension CityPopup {
    
    func presentationDispatchServiceDidStartOperation() {
        parentViewService.backgroundViewAnimate(shouldShow: true)
    }
    
    func presentationDispatchServiceWillComplete(operation: PresentOperation, areThereActiveOperations: Bool) {
        guard !areThereActiveOperations else { return }
        parentViewService.backgroundViewAnimate(shouldShow: false) { [weak parentViewService] in
            parentViewService?.stopUsingBackground()
        }
    }
    
    func presentationDispatchServiceDidComplete(operation: PresentOperation, areThereActiveOperations: Bool) {
        guard !areThereActiveOperations else { return }
        parentViewService.removeCreatedWindow()
    }
    
}
