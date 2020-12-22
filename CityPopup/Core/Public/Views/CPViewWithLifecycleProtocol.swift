//
//  CPViewWithLifecycleProtocol.swift
//  CityPopup
//
//  Created by Георгий Сабанов on 13.10.2020.
//

import UIKit

public protocol CPViewWithLifecycleProtocol: UIView {
    
    func willAppear()
    func didAppear()
    func willDisappear()
    func didDisappear()

}

public extension CPViewWithLifecycleProtocol {
    
    func willAppear() {}
    func didAppear() {}
    func willDisappear() {}
    func didDisappear() {}

}
