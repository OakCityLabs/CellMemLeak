//
//  D1StatusItem.swift
//  CellMemLeak
//
//  Created by Jay Lyerly on 3/26/21.
//

import Foundation
import UIKit

enum D1StatusItem: Hashable {
    
    case header(D1StatusSection)        // header text, section
    case keyValue(String, String)               // key, value
    case singleLine(String)                     // line of text
    case doubleValue(String, Double, String)    // label, value, units
    case buttonValue(String, UIAction)          // label, action for button
    
    var text: String? {
        switch self {
        case .header(let section):
            return section.rawValue
        case .keyValue(let key, let value):
            return "\(key): \(value)"
        case .singleLine(let txt):
            return txt
        case .doubleValue(let key, let value, let units):
            return "\(key): \(value) \(units)"
        case .buttonValue(let txt, _):
            return txt
        }
    }
    
    func font() -> UIFont {
        return UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }
    
    func buttonFont() -> UIFont {
        return UIFont.systemFont(ofSize: UIFont.systemFontSize)
    }
    
    func backgroundColor() -> UIColor {
        return .systemBackground
    }

}
