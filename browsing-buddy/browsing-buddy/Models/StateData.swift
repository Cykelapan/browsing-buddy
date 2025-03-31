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
    let website : String //Namn på hemsidan så det är lättare att se i JSON filer
    let device : String //Vilken device tagit för
    let state : String //Tanken är att varje sida kan ha Initial som alltid fungerar, sen gå till x, y eller z
    
    let webCommands : [WebAction]
    let uiButtons : [UIButtonData]
    
}
