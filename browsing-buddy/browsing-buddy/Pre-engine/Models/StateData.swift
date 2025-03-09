//
//  StateData.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import Foundation


struct StateData: Codable {
    // unique key for a specific state
    // could be combination of Webpage ,state (Where you are) and is it to iPhone or iPad
    let key : String
    let website : URL
    let state : String
    
    let webCommands : [WebCommand]
    let uiButtons : [UIButtonData]
    
}
