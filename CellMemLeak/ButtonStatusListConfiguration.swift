//
//  ButtonStatusListConfiguration.swift
//  Callisto
//
//  Created by Jay Lyerly on 9/28/20.
//  Copyright © 2020 Oak City Labs. All rights reserved.
//

import Logging
import UIKit

struct ButtonStatusListConfiguration: UIContentConfiguration, Hashable {

    let label: String
    let action: UIAction
    let buttonFont: UIFont
    let labelFont: UIFont
        
    init(label: String,
         buttonFont: UIFont,
         labelFont: UIFont,
         action: UIAction) {
        self.label = label
        self.labelFont = labelFont
        self.buttonFont = buttonFont
        self.action = action
    }
    
    func makeContentView() -> UIView & UIContentView {
        return ButtonStatusListCell(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        // No updates yet
        return self
    }
}
