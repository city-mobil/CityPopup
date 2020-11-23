//
//  CPAlertView.swift
//  CityPopup
//
//  Created by Чилимов Павел on 03.11.2020.
//

import UIKit

public final class CPAlertView: UIView, CPPopupViewProtocol {
    
    // MARK: - Private types
    private enum Spec {
        static let minimumWidth: CGFloat = 200
    }
    
    // MARK: - Private subviews
    private lazy var contentStackView = UIStackView() ~> {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
    }
    private var coverView: UIView?
    private lazy var titleLabel = UILabel() ~> {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = style.titleFont
        $0.textAlignment = style.titleTextAlignment
        $0.numberOfLines = style.titleNumberOfLines
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    private lazy var messageLabel = UILabel() ~> {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = style.messageFont
        $0.textAlignment = style.messageTextAligment
        $0.numberOfLines = style.messageNumberOfLines
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    private lazy var actionsStackView = UIStackView() ~> {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.distribution = .fillEqually
        $0.axis = style.actionsAxis.axis
        $0.spacing = style.spacingBetweenActions
    }
    private var actions = [UIControl]()
    
    // MARK: - Private properties
    private let title: String?
    private let message: String?
    private let style: CPAlertStyle
    
    // MARK: - Init
    public init(title: String?, message: String?, style: CPAlertStyle = .default) {
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
extension CPAlertView {
    
    /// Add a cover view which will be displayed on top of the alert.
    /// - Parameter view: Some view as a cover.
    public func addCover(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        coverView = view
    }
    
    /// Add action object to the alert.
    /// - Parameters:
    ///   - action: Action object which looks like a button and will be displayed on bottom of the alert.
    ///   - dismissOnTap: A flag to determine will be the alert dismissed on action tap.
    public func addAction(_ action: CPAlertActionView, dismissOnTap: Bool = true) {
        addAction(action as UIControl, dismissOnTap: dismissOnTap)
    }
    
    /// Add action objects to the alert.
    /// - Parameters:
    ///   - actions: Array of action objects which look like a buttons and will be displayed on bottom of the alert.
    ///   - dismissOnTap: A flag to determine will be the alert dismissed on actions tap.
    public func addActions(_ actions: [CPAlertActionView], dismissOnTap: Bool = true) {
        addActions(actions as [UIControl], dismissOnTap: dismissOnTap)
    }
    
    /// Add custom action object to the alert.
    /// - Parameters:
    ///   - action: Custom action object which looks like a button and will be displayed on bottom of the alert.
    ///   - dismissOnTap: A flag to determine will be the alert dismissed on action tap.
    public func addAction(_ action: UIControl, dismissOnTap: Bool = true) {
        actions.append(action)
        if dismissOnTap {
            action.addTarget(self, action: #selector(actionTouched), for: .touchUpInside)
        }
    }
    
    /// Add custom action objects to the alert.
    /// - Parameters:
    ///   - actions: Array of custom action objects which look like a buttons and will be displayed on bottom of the alert.
    ///   - dismissOnTap: A flag to determine will be the alert dismissed on actions tap.
    public func addActions(_ actions: [UIControl], dismissOnTap: Bool = true) {
        actions.forEach { self.addAction($0, dismissOnTap: dismissOnTap) }
    }
    
}

// MARK: - PopupViewProtocol
extension CPAlertView {
    
    public func willAppear() {
        setupLayout()
    }
    
}

// MARK: - Private setups
extension CPAlertView {
    
    private func setupLayout() {
        widthAnchor.constraint(greaterThanOrEqualToConstant: Spec.minimumWidth).isActive = true
        
        // Content
        contentStackView.backgroundColor = backgroundColor
        embedInScrollView(
            view: contentStackView,
            offsets: style.contentMargin,
            scrollingByAxis: .vertical,
            backgroundColor: backgroundColor
        )
        
        // Cover view
        if let coverView = coverView {
            contentStackView.addArrangedSubview(coverView)
            if let coverViewHeight = style.coverViewHeight {
                coverView.heightAnchor.constraint(equalToConstant: coverViewHeight).isActive = true
            }
        }
        
        // Title
        if let title = title {
            titleLabel.text = title
            titleLabel.backgroundColor = backgroundColor
            contentStackView.addArrangedSubview(titleLabel)
        }
        
        // Message
        if let message = message {
            messageLabel.text = message
            contentStackView.addArrangedSubview(messageLabel)
            messageLabel.backgroundColor = backgroundColor
        }
        
        if contentStackView.arrangedSubviews.isEmpty {
            assertionFailure("Content of an alert can not be empty")
        }
        
        // Actions
        if !actions.isEmpty {
            actionsStackView.backgroundColor = backgroundColor
            
            switch style.actionsAxis {
            case .horizontal(let shouldFitIntoContainer):
                if shouldFitIntoContainer {
                    contentStackView.addArrangedSubview(actionsStackView)
                    
                } else {
                    contentStackView.embedInScrollView(
                        view: actionsStackView,
                        offsets: .zero,
                        scrollingByAxis: style.actionsAxis.axis,
                        backgroundColor: backgroundColor
                    )
                }
                
            case .vertical:
                contentStackView.addArrangedSubview(actionsStackView)
            }
            
            actions.forEach { action in
                actionsStackView.addArrangedSubview(action)
            }
        }
        
        setupContentSpacings()
    }
    
    private func setupContentSpacings() {
        if let coverView = coverView {
            contentStackView.setSpacing(style.spacingAfterCoverView, after: coverView)
        }
        if title != nil {
            contentStackView.setSpacing(style.spacingAfterTitle, after: titleLabel)
        }
        if message != nil {
            contentStackView.setSpacing(style.spacingAfterMessage, after: messageLabel)
        }
    }
    
}

// MARK: - Private UI interactions
extension CPAlertView {
    
    @objc
    private func actionTouched() {
        hide()
    }
    
}
