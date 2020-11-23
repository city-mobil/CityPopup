//
//  SimpleAlertView.swift
//  CityPopup
//
//  Created by Георгий Сабанов on 09.10.2020.
//

import UIKit

// TODO: - (p.chilimov) Удалить
public final class SimpleAlertView: UIView, CPPopupViewProtocol {
    
    private let textLabel = UILabel() ~> {
        $0.font = .systemFont(ofSize: 15)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    private let okButton = UIButton() ~> {
        $0.setTitle("OK", for: .normal)
        $0.addTarget(self, action: #selector(okAction), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    
    public init(text: String) {
        super.init(frame: .zero)
        textLabel.text = text
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        configureViews()
    }
    
    private func configureViews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(textLabel)
        addSubview(okButton)
        
        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        
        okButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 16).isActive = true
        okButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        okButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        okButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        okButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc private func okAction() {
        hide()
    }
    
    public func willAppear() {
        textLabel.alpha = 0
        okButton.alpha = 0
    }
    
    public func didAppear() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
            self.textLabel.alpha = 1
            self.okButton.alpha = 1
        })
    }
}
