//
//  CPAlertActionView.swift
//  CityPopup
//
//  Created by Чилимов Павел on 05.11.2020.
//

import UIKit

public final class CPAlertActionView: UIControl, AnimatedPressViewProtocol {
    
    // MARK: - Public types
    public enum Side {
        case left, right
    }
    
    // MARK: - Private types
    private enum Spec {
        static let pressAnimationDuration: TimeInterval = 0.05
    }
    
    // MARK: - Private subviews
    private lazy var contentStackView = UIStackView() ~> {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isUserInteractionEnabled = false
        $0.spacing = style.contentHorizontalSpacing
    }
    private lazy var textLabel = UILabel() ~> {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = style.textFont
        $0.textColor = style.textColor
        $0.textAlignment = style.textAlignment
        $0.numberOfLines = 1
    }
    
    // MARK: - Private properties
    private let text: String?
    private let style: CPAlertActionStyle
    private let handler: (() -> Void)?
    
    // MARK: - Init
    public init(text: String?, style: CPAlertActionStyle = .default, handler: (() -> Void)? = nil) {
        self.text = text
        self.style = style
        self.handler = handler
        
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
        setupLayout()
    }
    
}

// MARK: - Public methods
extension CPAlertActionView {
    
    /// Add image to the action object.
    /// - Parameters:
    ///   - image: Required image.
    ///   - side: Side of the action object.
    ///   - contentMode: Determine how to image will be laid outed.
    ///   - shouldFillOtherSide: A flag used to determine will be an empty view with same size as image view created on the other side.
    public func add(
        image: UIImage,
        toSide side: Side,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        shouldFillOtherSide: Bool = false)
    {
        let imageView = UIImageView(image: image)
        imageView.contentMode = contentMode
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageRatio = image.size.width / image.size.height
        let imageWidth = (style.height - style.contentMargin.top - style.contentMargin.bottom) * imageRatio
        imageView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        
        let emptyView: () -> UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
            return view
        }
        
        switch side {
        case .left:
            contentStackView.insertArrangedSubview(imageView, at: 0)
            if shouldFillOtherSide {
                contentStackView.addArrangedSubview(emptyView())
            }
            
        case .right:
            contentStackView.addArrangedSubview(imageView)
            if shouldFillOtherSide {
                contentStackView.insertArrangedSubview(emptyView(), at: 0)
            }
        }
    }
    
}

// MARK: - UIControl
extension CPAlertActionView {
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        pressAnimation(isBeginning: true)
        return super.beginTracking(touch, with: event)
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        guard let location = touch?.location(in: self),
              bounds.contains(location)
        else {
            pressAnimation(isBeginning: false)
            return
        }
        
        handler?()
        pressAnimation(isBeginning: false)
    }
    
    public override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        
        pressAnimation(isBeginning: false)
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        guard bounds.contains(location) else {
            pressAnimation(isBeginning: false)
            return false
        }
        return true
    }
    
}

// MARK: - Private setups
extension CPAlertActionView {
    
    private func setupLayout() {
        heightAnchor.constraint(equalToConstant: style.height).isActive = true
        
        // Content stack view
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: style.contentMargin.left),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: style.contentMargin.top),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -style.contentMargin.right),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -style.contentMargin.bottom)
        ])
        
        // Title
        if let text = text {
            textLabel.text = text
            contentStackView.addArrangedSubview(textLabel)
        }
        
        if contentStackView.arrangedSubviews.isEmpty {
            assertionFailure("Content of an alert can not be empty")
        }
    }
    
}

// MARK: - Private animations
extension CPAlertActionView {
    
    private func pressAnimation(isBeginning: Bool) {
        playPressAnimation(
            scale: isBeginning ? 0.98 : 1,
            backgroundColor: isBeginning ? style.backgroundColor.darker() : style.backgroundColor,
            duration: Spec.pressAnimationDuration
        )
    }
    
}
