//
//  D1StatusSection.swift
//  CellMemLeak
//
//  Created by Jay Lyerly on 3/27/21.
//

import Foundation
import UIKit

struct D1StatusSection: Hashable, Equatable, RawRepresentable {
    let rawValue: String
    let autoExpand: Bool

    init(_ rawValue: String, autoExpand: Bool = true) {
        self.init(rawValue: rawValue, autoExpand: autoExpand)
    }

    init(rawValue: String, autoExpand: Bool = true) {
        self.rawValue = rawValue
        self.autoExpand = autoExpand
    }
    
    init(rawValue: String) {
        self.rawValue = rawValue
        self.autoExpand = true
    }
}

extension D1StatusSection {
    static let environment = D1StatusSection("Environment", autoExpand: false)
    static let packages = D1StatusSection("Packages", autoExpand: false)
    static let info = D1StatusSection("Info")
    static let cloudStorage = D1StatusSection("Cloud Storage")
}
