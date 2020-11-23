//
//  AlertsViewController.swift
//  CityPopupExamples
//
//  Created by Чилимов Павел on 23.11.2020.
//

import UIKit
import CityPopup

final class AlertsViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        setupShowAlertsButton()
        setupBackgroundForPopups()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.backgroundColor = UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1
        )
    }
    
}

// MARK: - Private methods
extension AlertsViewController {
    
    @objc
    private func showAlerts() {
        showFirstAlert()
    }
    
    private func showFirstAlert() {
        let alertView = CPAlertView(
            title: "First alert",
            message: "This alert is showing the cover image, title, message and some vertical actions",
            style: .init(coverViewHeight: 100)
        )
        
        let coverImageView = UIImageView(image: #imageLiteral(resourceName: "Cover"))
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 8
        alertView.addCover(coverImageView)
        
        CityPopup.shared.show(
            view: alertView,
            animator: CPSlideAnimator(direction: .up),
            attributes: .init(
                margins: .init(top: 24, left: 24, bottom: 24, right: 24)
            )
        )
    }
    
}

// MARK: - Private setups
extension AlertsViewController {
    
    private func setupShowAlertsButton() {
        let showAlertsButton = UIButton()
        
        showAlertsButton.backgroundColor = .systemBlue
        showAlertsButton.setTitle("Show", for: .normal)
        showAlertsButton.addTarget(self, action: #selector(showAlerts), for: .touchUpInside)
        showAlertsButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(showAlertsButton)
        
        showAlertsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        showAlertsButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        showAlertsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        showAlertsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupBackgroundForPopups() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        CityPopup.shared.setup(backgroundView: backgroundView)
    }
    
}
