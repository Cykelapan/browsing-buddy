//
//  WebActionDev.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-26.
//

import Foundation


struct WebActionDev {
    let websiteUrl : String
    let functionToCall : FunctionToCall
    let jsElementKey : String
    let willNavigate : Bool
    
    var extractFromUser : ExtractFromUser = .NOTHING
    var valueToInject: String = "What to inject"
    var accessCalendar : Bool = false
    var informationTitle : String = "Information"
    var descriptionMessage : String = "Long description for X"
}
