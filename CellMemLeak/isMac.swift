//
//  isMac.swift
//  CellMemLeak
//
//  Created by Jay Lyerly on 3/26/21.
//

import Foundation

#if targetEnvironment(macCatalyst)
let isMac = true
#else
let isMac = false
#endif
