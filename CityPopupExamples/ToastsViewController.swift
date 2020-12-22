//
//  ToastsViewController.swift
//  CityPopupExamples
//
//  Created by Георгий Сабанов on 24.11.2020.
//

import UIKit
import CityPopup

final class ToastsViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        setupShowToastsButton()
        // Call a background setup.
        setupBackgroundForPopups()
    }
        
}

// MARK: - Private methods
extension ToastsViewController {
    
    @objc
    private func showToasts() {
        // This toasts will be added to the queue which will show them according to it priority.
        showSimpleToast()
        showToastWithBottomAlignmentAndAutodismiss()
        showAchievementToastRTL()
        showAchievementToastLTR()
        // Popups show in respect of their priority.
        showAchievementToastHighPriority()
        
        // You can also change the popup animation.
        showAchievementToastSwipeLeft()
    }
    
    private func showSimpleToast() {
        // Create the toast view instance with title, message and leading view.
        // Note:
        // - The `style` parameter has a lot of settings to customize the toast view.
        let toastView = CPToastView(
            title: "First toast.",
            message: "This toast is showing the leading view, title and message.",
            style: .init(
                titleTextAlignment: .natural,
                titleNumberOfLines: 2,
                messageTextAligment: .natural,
                messageNumberOfLines: 6,
                verticalSpacingAfterTitle: 4
            )
        )
        
        // Add leading view with some image.
        let leadingImageView = UIImageView(image: #imageLiteral(resourceName: "Cover"))
        leadingImageView.contentMode = .scaleAspectFill
        leadingImageView.clipsToBounds = true
        leadingImageView.layer.cornerRadius = 8
        toastView.add(leadingView: leadingImageView, width: 32, height: 32)

        // Add tap action for toast
        toastView.tapHandler = {
            print("Toast simple tap action")
        }
        
        // Add swipe to hide recognition to toast
        toastView.setHideSwipeGestureEnabled(withDirection: .up)
                
        // Show the toast using the animator with sliding down animation.
        // Specify margins to a container of the toast.
        // Note:
        // - The animator is using not only to show a popup but to hide by default.
        // - CPSlideAnimator has another parameters for init, feel free to use it on need.
        // - CPSlideAnimator will hide the popup with reverse direction by default.
        // - The `attributes` parameter has a lot of settings to customize show operation.
        CityPopup.shared.show(
            popup: toastView,
            animator: CPSlideAnimator(direction: .down),
            attributes: .init(
                position: .top,
                margins: .init(top: 24, left: 24, bottom: 24, right: 24)
            )
        )
    }
    
    private func showToastWithBottomAlignmentAndAutodismiss() {
        // Create the toast view instance with title, message and leading view.
        // Note:
        // - The `style` parameter has a lot of settings to customize the toast view.
        let toastView = CPToastView(
            title: "Second toast.",
            message: "This toast is showing title and message. It is aligned at the bottom of the screen and autodismisses in 3 seconds. Text alignment is center",
            style: .init(
                titleTextAlignment: .center,
                titleNumberOfLines: 2,
                messageTextAligment: .center,
                messageNumberOfLines: 6,
                verticalSpacingAfterTitle: 4
            )
        )
                
        // Add swipe to hide recognition to toast with '.down' direction
        toastView.setHideSwipeGestureEnabled(withDirection: .down)
        
        // Show the toast using the animator with sliding up animation.
        // Specify margins to a container of the toast.
        // Note:
        // - The animator is using not only to show a popup but to hide by default.
        // - CPSlideAnimator has another parameters for init, feel free to use it on need.
        // - CPSlideAnimator will hide the popup with reverse direction by default.
        // - The `attributes` parameter has a lot of settings to customize show operation.
        CityPopup.shared.show(
            popup: toastView,
            animator: CPSlideAnimator(direction: .up),
            attributes: .init(
                autodismissDelay: 3,
                position: .bottom,
                margins: .init(top: 24, left: 24, bottom: 24, right: 24)
            )
        )
    }
    
    func showAchievementToastHighPriority() {
        // Configure toast styles.
        let toastStyle = CPToastStyle(
            cornerRadius: 8,
            backgroundColor: UIColor.black.withAlphaComponent(0.8),
            contentMargin: .init(top: 16, left: 16, bottom: 16, right: 16),
            titleFont: .systemFont(ofSize: 16, weight: .bold),
            titleTextAlignment: .natural,
            titleNumberOfLines: 2,
            titleTextColor: .white,
            messageFont: .systemFont(ofSize: 14, weight: .regular),
            messageTextAligment: .natural,
            messageNumberOfLines: 0,
            messageTextColor: .white,
            horizontalSpacingAfterLeadingContainer: 16,
            verticalSpacingAfterTitle: 4,
            horizontalSpacingAfterTitle: 8
        )
        
        // Create the toast view instance with title, message and leading view.
        let toastView = CPToastView(title: "Achievement unlocked", message: "High priority popup ninja", style: toastStyle)
        
        // Add leading view with some image.
        let leadingImageView = UIImageView(image: #imageLiteral(resourceName: "Star"))
        leadingImageView.contentMode = .center
        leadingImageView.clipsToBounds = true
        toastView.add(leadingView: leadingImageView, width: 32)
        
        // Add swipe to hide recognition to toast with '.up' direction
        toastView.setHideSwipeGestureEnabled(withDirection: .up)
        
        // Show the toast using the animator with sliding down animation.
        // Specify margins to a container of the toast.
        // Note:
        // - The animator is using not only to show a popup but to hide by default.
        // - CPSlideAnimator has another parameters for init, feel free to use it on need.
        // - CPSlideAnimator will hide the popup with reverse direction by default.
        // - The `attributes` parameter has a lot of settings to customize show operation.
        CityPopup.shared.show(
            popup: toastView,
            animator: CPSlideAnimator(direction: .down),
            attributes: .init(
                position: .top,
                margins: .init(top: 24, left: 24, bottom: 24, right: 24),
                priority: .high
            )
        )
    }
    
    func showAchievementToastSwipeLeft() {
        // Configure toast styles.
        let toastStyle = CPToastStyle(
            cornerRadius: 8,
            backgroundColor: UIColor.black.withAlphaComponent(0.8),
            contentMargin: .init(top: 16, left: 16, bottom: 16, right: 16),
            titleFont: .systemFont(ofSize: 16, weight: .bold),
            titleTextAlignment: .natural,
            titleNumberOfLines: 2,
            titleTextColor: .white,
            messageFont: .systemFont(ofSize: 14, weight: .regular),
            messageTextAligment: .natural,
            messageNumberOfLines: 0,
            messageTextColor: .white,
            horizontalSpacingAfterLeadingContainer: 16,
            verticalSpacingAfterTitle: 4,
            horizontalSpacingAfterTitle: 8
        )
        
        // Create the toast view instance with title, message and leading view.
        let toastView = CPToastView(title: "Achievement unlocked", message: "Left side animation popup", style: toastStyle)
        
        // Add leading view with some image.
        let leadingImageView = UIImageView(image: #imageLiteral(resourceName: "Star"))
        leadingImageView.contentMode = .center
        leadingImageView.clipsToBounds = true
        toastView.add(leadingView: leadingImageView, width: 32)
        
        // Add swipe to hide recognition to toast with '.left' direction
        toastView.setHideSwipeGestureEnabled(withDirection: .left)
        
        // Show the toast using the animator with sliding right animation.
        // Specify margins to a container of the toast.
        // Note:
        // - The animator is using not only to show a popup but to hide by default.
        // - CPSlideAnimator has another parameters for init, feel free to use it on need.
        // - CPSlideAnimator will hide the popup with reverse direction by default.
        // - The `attributes` parameter has a lot of settings to customize show operation.
        CityPopup.shared.show(
            popup: toastView,
            animator: CPSlideAnimator(direction: .right),
            attributes: .init(
                position: .top,
                margins: .init(top: 24, left: 24, bottom: 24, right: 24),
                priority: .high
            )
        )
    }
    
    //Show toast with right-to-left text direction.
    func showAchievementToastRTL() {
        // Configure toast styles.
        let toastStyle = CPToastStyle(
            cornerRadius: 8,
            backgroundColor: UIColor.black.withAlphaComponent(0.8),
            contentMargin: .init(top: 16, left: 16, bottom: 16, right: 16),
            titleFont: .systemFont(ofSize: 16, weight: .bold),
            titleTextAlignment: .natural,
            titleNumberOfLines: 2,
            titleTextColor: .white,
            messageFont: .systemFont(ofSize: 14, weight: .regular),
            messageTextAligment: .natural,
            messageNumberOfLines: 0,
            messageTextColor: .white,
            horizontalSpacingAfterLeadingContainer: 16,
            verticalSpacingAfterTitle: 4,
            horizontalSpacingAfterTitle: 8
        )
        
        // Create the toast view instance with title, message and leading view.
        let toastView = CPToastView(title: "Achievement unlocked", message: "Popup ninja Right-To-Left", style: toastStyle)
        
        // Add leading view with some image.
        let leadingImageView = UIImageView(image: #imageLiteral(resourceName: "Star"))
        leadingImageView.contentMode = .center
        leadingImageView.clipsToBounds = true
        toastView.add(leadingView: leadingImageView, width: 32)

        // Leading and trailing views support language directions.
        toastView.semanticContentAttribute = .forceRightToLeft

        // Add swipe to hide recognition to toast with '.up' direction
        toastView.setHideSwipeGestureEnabled(withDirection: .up)
        
        // Show the toast using the animator with sliding down animation.
        // Specify margins to a container of the toast.
        // Note:
        // - The animator is using not only to show a popup but to hide by default.
        // - CPSlideAnimator has another parameters for init, feel free to use it on need.
        // - CPSlideAnimator will hide the popup with reverse direction by default.
        // - The `attributes` parameter has a lot of settings to customize show operation.
        CityPopup.shared.show(
            popup: toastView,
            animator: CPSlideAnimator(direction: .down),
            attributes: .init(
                position: .top,
                margins: .init(top: 24, left: 24, bottom: 24, right: 24)
            )
        )
    }
    
    //Show toast with left-to-right text direction.
    func showAchievementToastLTR() {
        // Configure toast styles.
        let toastStyle = CPToastStyle(
            cornerRadius: 8,
            backgroundColor: UIColor.black.withAlphaComponent(0.8),
            contentMargin: .init(top: 16, left: 16, bottom: 16, right: 16),
            titleFont: .systemFont(ofSize: 16, weight: .bold),
            titleTextAlignment: .natural,
            titleNumberOfLines: 2,
            titleTextColor: .white,
            messageFont: .systemFont(ofSize: 14, weight: .regular),
            messageTextAligment: .natural,
            messageNumberOfLines: 0,
            messageTextColor: .white,
            horizontalSpacingAfterLeadingContainer: 16,
            verticalSpacingAfterTitle: 4,
            horizontalSpacingAfterTitle: 8
        )
        
        // Create the toast view instance with title, message and leading view.
        let toastView = CPToastView(title: "Achievement unlocked", message: "Popup ninja Left-To-Right", style: toastStyle)
        
        // Add leading view with some image.
        let leadingImageView = UIImageView(image: #imageLiteral(resourceName: "Star"))
        leadingImageView.contentMode = .center
        leadingImageView.clipsToBounds = true
        toastView.add(leadingView: leadingImageView, width: 32)
        
        // Leading and trailing views support language directions.
        toastView.semanticContentAttribute = .forceLeftToRight
        
        // Add swipe to hide recognition to toast with '.up' direction
        toastView.setHideSwipeGestureEnabled(withDirection: .up)
        
        // Show the toast using the animator with sliding down animation.
        // Specify margins to a container of the toast.
        // Note:
        // - The animator is using not only to show a popup but to hide by default.
        // - CPSlideAnimator has another parameters for init, feel free to use it on need.
        // - CPSlideAnimator will hide the popup with reverse direction by default.
        // - The `attributes` parameter has a lot of settings to customize show operation.
        CityPopup.shared.show(
            popup: toastView,
            animator: CPSlideAnimator(direction: .down),
            attributes: .init(
                position: .top,
                margins: .init(top: 24, left: 24, bottom: 24, right: 24)
            )
        )
    }
    
}

// MARK: - Private setups
extension ToastsViewController {
    
    private func setupShowToastsButton() {
        let showToastsButton = UIButton()
        
        showToastsButton.backgroundColor = .systemBlue
        showToastsButton.setTitle("Show", for: .normal)
        showToastsButton.addTarget(self, action: #selector(showToasts), for: .touchUpInside)
        showToastsButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(showToastsButton)
        
        showToastsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        showToastsButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        showToastsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        showToastsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
