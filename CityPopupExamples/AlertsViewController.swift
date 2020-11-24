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
        // Call a background setup.
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
        // This alerts will be added to the queue which will show them according to it priority.
        showSimpleAlert()
    }
    
    private func showSimpleAlert() {
        // Create the alert view instance with title and message.
        // Specify height of cover view which will be added later.
        // Notes:
        // - The `style` parameter has a lot of settings to customize the alert view;
        // - Specify height for cover view manually if the view's height can not be predicted.
        let alertView = CPAlertView(
            title: "First alert.",
            message: "This alert is showing the cover image, title, message and some vertical actions.",
            style: .init(coverViewHeight: 100)
        )
        
        // Add cover view with some image.
        let coverImageView = UIImageView(image: #imageLiteral(resourceName: "Cover"))
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 8
        alertView.addCover(coverImageView)
        
        // Create the action with default style and with tap handler which will open the link.
        let docsLinkAction = CPAlertActionView(text: "Docs") {
            // TODO: - (p.chilimov) Вставить ссылку на описание алертов
            guard let url = URL(string: "https://github.com/city-mobil/CityPopup"),
                  UIApplication.shared.canOpenURL(url)
            else {
                return
            }
            UIApplication.shared.openURL(url)
        }
        // Add the image to the right side.
        // Notes:
        // - To keep the text in the middle of the action set `true` to `shouldFillOtherSide`,
        // it will create an empty view with same size as the image view.
        // - To support dark and light mode specify tintColor with dynamic color.
        docsLinkAction.add(image: #imageLiteral(resourceName: "Link"), toSide: .right, shouldFillOtherSide: true, tintColor: CPColor.black_white)
        // Add action to the alert and forbid alert dismiss on the action tap.
        alertView.addAction(docsLinkAction, dismissOnTap: false)
        
        // Create the action that do nothing and has the `.cancel` style.
        let continueAction = CPAlertActionView(text: "Continue", style: .cancel)
        // Add action to the alert. Dismiss the alert on action tap will be performed automatically.
        alertView.addAction(continueAction)
        
        // Show the alert using the animator with sliding up animation.
        // Specify margins to a container of the alert.
        // Notes:
        // - The animator is using not only to show a popup but to hide by default;
        // - CPSlideAnimator has another parameters for init, feel free to use it on need;
        // - CPSlideAnimator will hide the popup with reverse direction by default;
        // - The `attributes` parameter has a lot of settings to customize show operation.
        CityPopup.shared.show(
            popup: alertView,
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
        // Create simple background.
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        // Setup a background which will be show when first popup in queue will be displayed.
        // Note:
        // - The fade animation will be used to show the background view.
        CityPopup.shared.setup(backgroundView: backgroundView)
    }
    
}
