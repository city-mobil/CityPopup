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
extension ToastsViewController {
    
    @objc
    private func showToasts() {
        // This toasts will be added to the queue which will show them according to it priority.
        showSimpleToast()
    }
    
    private func showSimpleToast() {
        // Create the toast view instance with title, message and leading view.
        // Notes:
        // - The `style` parameter has a lot of settings to customize the toast view;
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

                
        // Show the toast using the animator with sliding up animation.
        // Specify margins to a container of the toast.
        // Notes:
        // - The animator is using not only to show a popup but to hide by default;
        // - CPSlideAnimator has another parameters for init, feel free to use it on need;
        // - CPSlideAnimator will hide the popup with reverse direction by default;
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
