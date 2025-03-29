//
//  UIButtons.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import Foundation

struct UIButtonData : Codable, Hashable, Equatable {
    let buttonText : String
    let nextStateKey : String
    
    static func == (lhs: UIButtonData, rhs: UIButtonData) -> Bool {
        return lhs.buttonText == rhs.buttonText
    }
}
