//
//  StateData.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import Foundation


struct WebState: Codable {
    // unique key for a specific state
    // could be combination of Webpage ,state (Where you are) and is it to iPhone or iPad
    // Lägger till device
    
    let _id : String
    let website : String
    let device : String
    let state : String
    
    let webCommands : [WebAction]
    let uiButtons : [UIButtonData]
    
}
