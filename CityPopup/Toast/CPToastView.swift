//
//  CPToastView.swift
//  CityPopup
//
//  Created by Чилимов Павел on 12.11.2020.
//

import UIKit

public protocol CPToastViewDelegate: AnyObject {
    
    func toastViewWillAppear(_ toastView: CPToastView)
    func toastViewDidAppear(_ toastView: CPToastView)
    func toastViewWillDisappear(_ toastView: CPToastView)
    func toastViewDidDisappear(_ toastView: CPToastView)
    
}

public final class CPToastView: UIControl, CPPopupViewProtocol, AnimatedPressViewProtocol {
    
    // MARK: - Private types
    private enum Spec {
        static let minimumWidth: CGFloat = 200
        static let pressAnimationDuration: TimeInterval = 0.05
        static let moveAnimationDuration: TimeInterval = 0.3
        static let swipeThresholdVerticalCoefficient: CGFloat = 0.1
        static let swipeThresholdHorizontalCoefficient: CGFloat = 0.4
    }
    private enum Side {
        case leading, trailing
    }
    private struct FloatViewData {
        let view: UIView
        let width: CGFloat
        let height: CGFloat?
    }
    
    // MARK: - Public properties
    /// Handle tap on the toast.
    public var tapHandler: (() -> Void)?
    public weak var delegate: CPToastViewDelegate?
    
    // MARK: - Private subviews
    private lazy var contentStackView = PassthroughStackView() ~> {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private lazy var textsStackView = UIStackView() ~> {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isUserInteractionEnabled = false
        $0.axis = .vertical
    }
    private lazy var titleLabel = UILabel() ~> {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = style.titleFont
        $0.textColor = style.titleTextColor
        $0.textAlignment = style.titleTextAlignment
        $0.numberOfLines = style.titleNumberOfLines
        $0.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    private lazy var messageLabel = UILabel() ~> {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = style.messageFont
        $0.textColor = style.messageTextColor
        $0.textAlignment = style.messageTextAligment
        $0.numberOfLines = style.messageNumberOfLines
    }
    
    // MARK: - Private properties
    private let title: String
    private let message: String?
    private var leadingViewData: FloatViewData?
    private var trailingViewData: FloatViewData?
    private let style: CPToastStyle
    
    // Properties for the movement
    private var swipeHandler: ((CPDirection) -> Bool)?
    private var isSwipeEnabled = false
    private var allowedSwipeDirection: UISwipeGestureRecognizer.Direction?
    private var movingDirection: CPDirection?
    private var initialCenterPosition = CGPoint.zero
    private var lastTouchPosition = CGPoint.zero
    
    // MARK: - Init
    public init(title: String, message: String? = nil, style: CPToastStyle = .default) {
        self.title = title
        self.message = message
        self.style = style
        
        super.init(frame: .zero)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        clipsToBounds = true
    }
    
}

// MARK: - Public methods
extension CPToastView {
    
    /// Add a view which will be displayed on leading edge of the toast.
    /// - Parameters:
    ///   - leadingView: The view to display.
    ///   - width: Width of the leading view. Pay attention on the value to not confront with other toast's content.
    ///   - height: Height of the leading view. Nil height means that the leading view should be fit into leading container.
    public func add(leadingView: UIView, width: CGFloat, height: CGFloat? = nil) {
        leadingView.translatesAutoresizingMaskIntoConstraints = false
        leadingView.removeConstraints(constraints)
        
        leadingViewData = .init(
            view: leadingView,
            width: width,
            height: height
        )
    }
    
    /// Add a view which will be displayed on trailing edge of the toast.
    /// - Parameters:
    ///   - trailingView: The view to display.
    ///   - width: Width of the trailing view. Pay attention on the value to not confront with other toast's content.
    ///   - height: Height of the trailing view. Nil height means that the trailing view should be fit into trailing container.
    public func add(trailingView: UIView, width: CGFloat, height: CGFloat? = nil) {
        trailingView.translatesAutoresizingMaskIntoConstraints = false
        trailingView.removeConstraints(constraints)
        
        trailingViewData = .init(
            view: trailingView,
            width: width,
            height: height
        )
    }
    
    /// Enable swipe gesture.
    /// - Parameters:
    ///   - direction: Allowable directions for swipe gesture. This value is OptionSet type, so you can choose multiple directions.
    ///   - handler: Specify logic to handle swipe gesture with movement direction. Return `true` if you want to move the toast to its initial position.
    public func setSwipeGestureEnabled(
        withDirection direction: UISwipeGestureRecognizer.Direction = .up,
        handler: @escaping (CPDirection) -> Bool)
    {
        isSwipeEnabled = true
        allowedSwipeDirection = direction
        swipeHandler = handler
    }
    
    /// Enable swipe gesture for hiding of the toast.
    /// - Parameter direction: Allowable directions for swipe gesture. This value is OptionSet type, so you can choose multiple directions.
    public func setHideSwipeGestureEnabled(withDirection direction: UISwipeGestureRecognizer.Direction = .up) {
        setSwipeGestureEnabled(
            withDirection: direction,
            handler: { [weak self] direction in
                let slideAnimator = CPSlideAnimator(
                    direction: direction.inverted,
                    shouldUseFadeAnimation: false
                )
                self?.hide(usingAnimator: slideAnimator)
                return false
            }
        )
    }
    
}

// MARK: - PopupViewProtocol
extension CPToastView {
    
    public func willAppear() {
        delegate?.toastViewWillAppear(self)
        setupLayout()
    }
    
    public func didAppear() {
        delegate?.toastViewDidAppear(self)
        initialCenterPosition = center
    }
    
    public func willDisappear() {
        delegate?.toastViewWillDisappear(self)
    }
    
    public func didDisappear() {
        delegate?.toastViewDidDisappear(self)
    }
    
}

// MARK: - UIControl
extension CPToastView {
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        pressAnimationShouldBegan()
        moveAnimationShouldBegan(withTouch: touch)
        return super.beginTracking(touch, with: event)
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        // If moving direction exists then the swipe should be handled
        if movingDirection == nil {
            pressAnimationShouldEnd(withTouch: touch)
        } else {
            moveAnimationShouldFinished(withTouch: touch)
        }
    }
    
    public override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        pressAnimationShoudCanceled()
        moveAnimationShouldFinished()
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        pressAnimationShouldContinued(withTouch: touch)
        moveAnimationShouldContinued(withTouch: touch)
        return true
    }
    
}

// MARK: - Private setups
extension CPToastView {
    
    private func setupLayout() {
        widthAnchor.constraint(greaterThanOrEqualToConstant: Spec.minimumWidth).isActive = true
        
        // Content
        contentStackView.backgroundColor = .clear
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: style.contentMargin.left),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: style.contentMargin.top),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -style.contentMargin.right),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -style.contentMargin.bottom)
        ])
        
        // Texts
        textsStackView.backgroundColor = .clear
        contentStackView.addArrangedSubview(textsStackView)
        
        // Title
        titleLabel.text = title
        textsStackView.addArrangedSubview(titleLabel)
        
        // Message
        if let message = message {
            messageLabel.text = message
            textsStackView.addArrangedSubview(messageLabel)
        }
        
        // Side container views
        let leadingContainer = setupSideContainer(side: .leading)
        setupSideContainer(side: .trailing)
        
        setupContentSpacing(leadingContainer: leadingContainer)
    }
    
    private func setupContentSpacing(leadingContainer: UIView?) {
        if let leadingContainer = leadingContainer {
            contentStackView.setSpacing(style.horizontalSpacingAfterLeadingContainer, after: leadingContainer)
        }
        
        textsStackView.setSpacing(style.verticalSpacingAfterTitle, after: titleLabel)
        contentStackView.setSpacing(style.horizontalSpacingAfterTitle, after: textsStackView)
    }
    
    @discardableResult
    private func setupSideContainer(side: Side) -> UIView? {
        let isRightToLeftDirection = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
        let floatViewData: FloatViewData?
        let shouldInsertFirst: Bool
        switch side {
        case .leading:
            floatViewData = leadingViewData
            shouldInsertFirst = isRightToLeftDirection ? false : true
            
        case .trailing:
            floatViewData = trailingViewData
            shouldInsertFirst = isRightToLeftDirection ? true : false
        }
        
        guard let viewData = floatViewData else { return nil }
        
        let container = PassthroughView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.shouldPassthrough = true
        container.backgroundColor = .clear
        
        if shouldInsertFirst {
            contentStackView.insertArrangedSubview(container, at: 0)
        } else {
            contentStackView.addArrangedSubview(container)
        }
        
        let view = viewData.view
        container.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.topAnchor.constraint(equalTo: container.topAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            view.widthAnchor.constraint(equalToConstant: viewData.width)
        ])
        
        if let height = viewData.height {
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
            view.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor).isActive = true
            
        } else {
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        }
        
        return container
    }
    
}

// MARK: - Private press animation methods
extension CPToastView {
    
    private func pressAnimationShouldBegan() {
        guard tapHandler != nil else { return }
        pressAnimation(isBeginning: true)
    }
    
    private func pressAnimationShouldEnd(withTouch touch: UITouch?) {
        guard tapHandler != nil else { return }
        guard let location = touch?.location(in: self),
              bounds.contains(location)
        else {
            pressAnimation(isBeginning: false)
            return
        }
        
        tapHandler?()
        pressAnimation(isBeginning: false)
    }
    
    private func pressAnimationShoudCanceled() {
        guard tapHandler != nil else { return }
        pressAnimation(isBeginning: false)
    }
    
    private func pressAnimationShouldContinued(withTouch touch: UITouch) {
        guard tapHandler != nil,
              bounds.contains(touch.location(in: self))
        else {
            return
        }
        
        pressAnimation(isBeginning: false)
    }
    
    private func pressAnimation(isBeginning: Bool) {
        let includingViews = [contentStackView] + contentStackView.arrangedSubviews
        playPressAnimation(
            scale: isBeginning ? 0.98 : 1,
            backgroundColor: isBeginning ? style.backgroundColor.darker() : style.backgroundColor,
            duration: Spec.pressAnimationDuration,
            includingViews: includingViews
        )
    }
    
}

// MARK: - Private move animation methods
extension CPToastView {
    
    private func moveAnimationShouldBegan(withTouch touch: UITouch) {
        guard isSwipeEnabled else { return }
        lastTouchPosition = touch.location(in: self.superview)
    }
    
    private func moveAnimationShouldContinued(withTouch touch: UITouch) {
        guard isSwipeEnabled else { return }
        
        let position = calculateSwipePosition(withTouch: touch)
        translate(withPosition: position)
    }
    
    private func moveAnimationShouldFinished(withTouch touch: UITouch? = nil) {
        guard isSwipeEnabled else { return }
        
        defer { movingDirection = nil }
        
        guard let touch = touch,
              let movingDirection = movingDirection,
              isMovingAllowed(forDirection: movingDirection)
        else {
            translateToInitialPosition()
            return
        }
        
        let position = calculateSwipePosition(withTouch: touch)
        let mainAxisDistance = movingDirection.isAlongVertical ? position.y : position.x
        
        if abs(mainAxisDistance) > calculateSwipeThreshold(forDirection: movingDirection) {
            let shouldTranslateToInitialPosition = swipeHandler?(movingDirection)
            if shouldTranslateToInitialPosition == true {
                translateToInitialPosition()
            }
        } else {
            translateToInitialPosition()
        }
    }
    
    private func calculateSwipePosition(withTouch touch: UITouch) -> CGPoint {
        var position = touch.location(in: self.superview)
        position.x -= lastTouchPosition.x
        position.y -= lastTouchPosition.y
        
        return position
    }
    
    private func translate(withPosition position: CGPoint) {
        let movingDirection: CPDirection
        if let initialMovingDirection = self.movingDirection {
            movingDirection = calculateMovingDirection(withPosition: position, alongSameAxisWithDirection: initialMovingDirection)
            
        } else {
            movingDirection = calculateMovingDirection(withPosition: position)
        }
        
        let shouldResist = !isMovingAllowed(forDirection: movingDirection)
        center = calculateTargetPoint(withPosition: position, movingDirection: movingDirection, shouldResist: shouldResist)
        self.movingDirection = movingDirection
    }
    
    private func calculateMovingDirection(withPosition position: CGPoint) -> CPDirection {
        if abs(position.x) >= abs(position.y) {
            return position.x >= 0 ? .right : .left
            
        } else {
            return position.y >= 0 ? .down : .up
        }
    }
    
    private func calculateMovingDirection(
        withPosition position: CGPoint,
        alongSameAxisWithDirection direction: CPDirection) -> CPDirection
    {
        switch direction {
        case .left, .right:
            return position.x >= 0 ? .right : .left
            
        case .up, .down:
            return position.y >= 0 ? .down : .up
        }
    }
    
    private func calculateTargetPoint(withPosition position: CGPoint, movingDirection: CPDirection, shouldResist: Bool) -> CGPoint {
        var targetPoint = CGPoint(x: initialCenterPosition.x, y: initialCenterPosition.y)
        
        switch movingDirection {
        case .left:
            targetPoint.x += shouldResist ? addResistance(toDistance: position.x) : position.x
            
        case .up:
            targetPoint.y += shouldResist ? addResistance(toDistance: position.y) : position.y
            
        case .right:
            targetPoint.x += shouldResist ? addResistance(toDistance: position.x) : position.x
            
        case .down:
            targetPoint.y += shouldResist ? addResistance(toDistance: position.y) : position.y
        }
        
        return targetPoint
    }
    
    private func addResistance(toDistance distance: CGFloat) -> CGFloat {
        let sign = distance.sign
        // TODO: - (p.chilimov) Надо посчитать сложноть обеих формул, чтобы понять, какую лучше использовать
//        let unsignedValue = sqrt(abs(distance))
        let unsignedValue = 10 * log10((abs(distance) / 10) + 1)
        return sign == .minus ? -unsignedValue : unsignedValue
    }
    
    private func isMovingAllowed(forDirection direction: CPDirection) -> Bool {
        guard let allowedSwipeDirection = allowedSwipeDirection else { return false }
        
        switch direction {
        case .left:
            return allowedSwipeDirection.contains(.left)
            
        case .up:
            return allowedSwipeDirection.contains(.up)
            
        case .right:
            return allowedSwipeDirection.contains(.right)
            
        case .down:
            return allowedSwipeDirection.contains(.down)
        }
    }
    
    private func calculateSwipeThreshold(forDirection direction: CPDirection) -> CGFloat {
        switch direction {
        case .up, .down:
            return UIScreen.main.bounds.height * Spec.swipeThresholdVerticalCoefficient
            
        case .left, .right:
            return UIScreen.main.bounds.width * Spec.swipeThresholdHorizontalCoefficient
        }
    }
    
    private func translateToInitialPosition() {
        UIView.animate(
            withDuration: Spec.moveAnimationDuration,
            delay: 0,
            options: .curveEaseInOut,
            animations: { [self] in
                center = initialCenterPosition
            }
        )
    }
    
}
