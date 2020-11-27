//
//  CPAttributes+InteractionHandling.swift
//  CityPopup
//
//  Created by Чилимов Павел on 09.10.2020.
//

extension CPAttributes {
    
    public enum InteractionHandling {
        /// Should passthrough an interaction or not
        case passthrough(Bool)
        /// Dismiss presented popup
        case dismiss
    }
    
}
