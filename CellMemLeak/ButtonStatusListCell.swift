//
//  ButtonStatusListCell.swift
//  Callisto
//
//  Created by Jay Lyerly on 9/27/20.
//  Copyright © 2020 Oak City Labs. All rights reserved.
//

import Logging
import UIKit

class ButtonStatusListCell: UIView, UIContentView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
        
    var logger = Logger(label: "Callisto.ButtonStatusListCell")

    // swiftlint:disable:next implicitly_unwrapped_optional
    private var currentConfiguration: ButtonStatusListConfiguration!
    
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? ButtonStatusListConfiguration else {
                return
            }
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: ButtonStatusListConfiguration) {
        super.init(frame: .zero)
        let objs = Bundle.main.loadNibNamed("ButtonStatusListCell",
                                            owner: self, options: nil)
        if let contentView = objs?.first as? UIView {
            addSubViewEdgeToEdge(contentView)
        }
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func apply(configuration: ButtonStatusListConfiguration) {
        
        currentConfiguration = configuration
        
        label.text = configuration.label
        label.font = configuration.labelFont
        button.removeAllActions()
        button.titleLabel?.font = configuration.buttonFont
        button.setTitle(configuration.action.title, for: [])
        button.addAction(configuration.action, for: .touchUpInside)
    }
}

extension UIControl {
    
    func removeAllActions() {
        enumerateEventHandlers { (action, _, event, _) in
            if let action = action {
                removeAction(action, for: event)
            }
        }
    }
}
