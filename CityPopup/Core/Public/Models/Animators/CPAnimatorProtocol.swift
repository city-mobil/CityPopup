//
//  CPAnimatorProtocol.swift
//  CityPopup
//
//  Created by Чилимов Павел on 10.11.2020.
//

import UIKit

public protocol CPAnimatorProtocol: CPHideAnimatorProtocol {
    
    /// This method will be called when the view should show.
    /// - Parameters:
    ///   - view: The view to show.
    ///   - completion: Call the completion when animation ends.
    /// - Important:
    /// The animation can be interrupted.
    /// Do not check `isCompleted` to call completion on success using native `UIView.animate` cause `isCompleted` can be `false`.
    func performShowAnimation(view: UIView, completion: @escaping () -> Void)
    
}

public protocol CPHideAnimatorProtocol {
    
    /// This method will be called when the view should hide.
    /// - Parameters:
    ///   - view: The view to hide.
    ///   - completion: Call the completion when animation ends.
    /// - Important:
    /// The animation can be interrupted.
    /// Do not check `isCompleted` to call completion on success using native `UIView.animate` cause `isCompleted` can be `false`.
    func performHideAnimation(view: UIView, completion: @escaping () -> Void)
    
}
