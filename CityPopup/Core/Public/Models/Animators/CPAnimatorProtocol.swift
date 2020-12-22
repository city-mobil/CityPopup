//
//  CPAnimatorProtocol.swift
//  CityPopup
//
//  Created by Чилимов Павел on 10.11.2020.
//

import UIKit

public protocol CPAnimatorProtocol: CPHideAnimatorProtocol {
    
    func performShowAnimation(view: UIView, completion: @escaping () -> Void)
    
}

public protocol CPHideAnimatorProtocol {
    
    func performHideAnimation(view: UIView, completion: @escaping () -> Void)
    
}
