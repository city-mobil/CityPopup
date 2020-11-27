//
//  AlertsViewController.swift
//  CityPopupExamples
//
//  Created by Чилимов Павел on 23.11.2020.
//

import UIKit
import CityPopup

/*
 You can find here some examples of using the predefined alerts (CPAlertView).
 The code below have many duplicates deliberately. This is for clarity of the example.
 */

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
        showThirstAlert()
        showSecondAlert()
        showThirdAlert()
    }
    
    private func showThirstAlert() {
        // Create the alert view instance with title and message.
        // Specify height of cover view which will be added later.
        // Notes:
        // - The `style` parameter has a lot of settings to customize the alert view;
        // - Specify height for cover view manually if the view's height can not be predicted.
        let alertView = CPAlertView(
            title: "First alert.",
            message: "This alert has been shown with slide animation and contains cover, title, message and some vertical actions.",
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
        // it will create an empty view with same size as the image view;
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
            animator: CPFlipAnimator(direction: .up),
            attributes: .init(
                margins: .init(top: 24, left: 24, bottom: 24, right: 24)
            )
        )
    }
    
    private func showSecondAlert() {
        // Create the alert view instance with message.
        // Notes:
        // - The `style` parameter has a lot of settings to customize the alert view;
        // - Specify `actionsAxis` in style to display actions horizontally in scroll view.
        let alertView = CPAlertView(
            title: nil,
            message: "Almost empty alert. You can scroll actions below.",
            style: .init(actionsAxis: .horizontal(shouldFitIntoContainer: false))
        )
        
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
        // Note:
        // - To support dark and light mode specify tintColor with dynamic color.
        docsLinkAction.add(image: #imageLiteral(resourceName: "Link"), toSide: .right, tintColor: CPColor.black_white)
        // Add action to the alert and forbid alert dismiss on the action tap.
        alertView.addAction(docsLinkAction, dismissOnTap: false)
        
        // Create the action that do nothing and has only image.
        let nothingAction = CPAlertActionView(text: "Do nothing")
        nothingAction.add(image: #imageLiteral(resourceName: "Cover"), toSide: .left, contentMode: .scaleAspectFill)
        // Add action to the alert. Dismiss the alert on action tap will be performed automatically.
        alertView.addAction(nothingAction, dismissOnTap: false)
        
        // Create the action that do nothing and has the `.cancel` style.
        let continueAction = CPAlertActionView(text: "Continue", style: .cancel)
        // Add action to the alert. Dismiss the alert on action tap will be performed automatically.
        alertView.addAction(continueAction)
        
        // Show the alert using the animator with sliding down animation.
        // Notes:
        // - The animator is using not only to show a popup but to hide by default;
        // - CPSlideAnimator has another parameters for init, feel free to use it on need;
        // - CPSlideAnimator will hide the popup with reverse direction by default;
        // - The `attributes` parameter has a lot of settings to customize show operation.
        CityPopup.shared.show(
            popup: alertView,
            animator: CPSlideAnimator(direction: .down),
            attributes: .init(position: .top)
        )
    }
    
    private func showThirdAlert() {
        let message = """
        This alert has been shown with fade animation.
        It is highly customized and it contains cover, title, message and two horizontal actions.
        The alert will be dismissed automatically in 24 sec.
        You can tap outside of the alert, the background of the controller view will change it color.
        If you tap on the show button new alerts will be created and added to the queue.
        """
        // Specify all available parameters for style.
        // Some of them will be described below.
        // Notes:
        // - Specify `contentMargin` to make indents between the alert edges and it contents;
        // - Specify `coverViewHeight` manually if the view's height can not be predicted;
        // - Specify `actionsAxis` to display actions horizontally. Actions will be fitted and maybe compressed.
        let alertStyle = CPAlertStyle(
            cornerRadius: 16,
            backgroundColor: CPColor.white_black,
            contentMargin: .init(top: 8, left: 8, bottom: 8, right: 8),
            coverViewHeight: 100,
            titleFont: .boldSystemFont(ofSize: 24),
            titleTextAlignment: .left,
            titleNumberOfLines: 1,
            messageFont: .boldSystemFont(ofSize: 18),
            messageTextAligment: .left,
            messageNumberOfLines: 0,
            actionsAxis: .horizontal(shouldFitIntoContainer: true),
            spacingAfterCoverView: 32,
            spacingAfterTitle: 8,
            spacingAfterMessage: 16,
            spacingBetweenActions: 4
        )
        // Create the alert view instance with title and message.
        let alertView = CPAlertView(
            title: "Third alert.",
            message: message,
            style: alertStyle
        )
        
        // Add cover view with some image.
        let coverImageView = UIImageView(image: #imageLiteral(resourceName: "Cover_2"))
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        coverImageView.layer.cornerRadius = 16
        alertView.addCover(coverImageView)
        
        // Create custom action style.
        // Specify all available parameters.
        let customActionStyle = CPAlertActionStyle(
            height: 64,
            cornerRadius: 16,
            backgroundColor: CPColor.black_white,
            contentMargin: .init(top: 16, left: 16, bottom: 16, right: 16),
            contentHorizontalSpacing: 4,
            textFont: .boldSystemFont(ofSize: 18),
            textColor: CPColor.white_black,
            textAlignment: .justified
        )
        
        // Create the action with custom style and with tap handler which will open the link.
        let docsLinkAction = CPAlertActionView(text: "Docs", style: customActionStyle) {
            // TODO: - (p.chilimov) Вставить ссылку на описание алертов
            guard let url = URL(string: "https://github.com/city-mobil/CityPopup"),
                  UIApplication.shared.canOpenURL(url)
            else {
                return
            }
            UIApplication.shared.openURL(url)
        }
        // Add the image to the right side.
        // Note:
        // - To support dark and light mode specify tintColor with dynamic color.
        docsLinkAction.add(
            image: #imageLiteral(resourceName: "Link"),
            toSide: .right,
            contentMode: .scaleAspectFit,
            shouldFillOtherSide: false,
            tintColor: CPColor.white_black
        )
        // Add action to the alert and forbid alert dismiss on the action tap.
        alertView.addAction(docsLinkAction, dismissOnTap: false)
        
        // Create the action that do nothing and set the custom style.
        let continueAction = CPAlertActionView(text: "Continue", style: customActionStyle)
        // Add action to the alert. Dismiss the alert on action tap will be performed automatically.
        alertView.addAction(continueAction)
        
        // Specify all available parameters for attributes.
        // Some of them will be described below.
        // Notes:
        // - Specify `autodismissDelay` to dismiss the alert automatically;
        // - Specify `backgroundInteractionHandling` to be able to tap on views behind the alert;
        // - Specify `position` to change the alert position;
        // - Specify `tags` to be able to found this alert by tags;
        // - Specify `shouldFitToContainer` to forbid alert crawling out of it container bounds.
        let attributes = CPAttributes(
            autodismissDelay: 24,
            backgroundInteractionHandling: .passthrough(true),
            position: .bottom,
            margins: .init(top: 40, left: 40, bottom: 40, right: 40),
            priority: .medium,
            tags: ["customized_alert"],
            shouldFitToContainer: true
        )
        // Show the alert using the animator with fade animation.
        // Note:
        // - The animator is using not only to show a popup but to hide by default.
        CityPopup.shared.show(
            popup: alertView,
            animator: CPFadeAnimator(showDuration: 0.5, hideDuration: 0.5),
            attributes: attributes
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
