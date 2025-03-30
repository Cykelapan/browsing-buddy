//
//  WebInteractions.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import Foundation


/*
 
 struct WebAction {
     let functionToCall: String
     let parameter: String
     let willNavigate: Bool // måste vara med ifall navigation sker vid en action
     let extractFromUser: String?
     let title: String?
     let acessCalendar: Bool?
     

     init(functionToCall: String, parameter: String, willNavigate: Bool = false, extractFromUser: String? = nil, title: String? = nil,
          accessCalendar: Bool? = nil) {
         self.functionToCall = functionToCall
         self.parameter = parameter
         self.willNavigate = willNavigate
         self.extractFromUser = extractFromUser
         self.title = title
         self.acessCalendar = accessCalendar
     }
 }
 
 
 
 */
//All diffrent keys?
struct JSElementKeys: Codable {
    let className : String?
    let classPath : String?
    let elementId : String?
    let elementTag : String?
    let cssSelector : String?
    let xPath : String?
}

/* what is required from the db
'websiteUrl',
'functionToCall',
'extractFromUser',
'willNavigate',
'jsElementKeys'
rest is optional
*/
struct WebAction : Codable{
    // The full URL (including path) where the action should be performed.
    let websiteUrl : String
    
    // Defines which function in the engine to call
    let functionToCall : FunctionToCall
        // If the action will trigger a page navigation
    let willNavigate : Bool
    
    // Defines the source of the value to be injected.
    //    - If `.NOTHING`, `valueToInject` will be used.
    //    - Otherwise, the value is extracted from `UserSession`.
    let extractFromUser : ExtractFromUser
    
    let valueToInject: String
    
    // Whether the action requires access to the calendar.
    let accessCalendar : Bool
    
    // Title displayed in the pop-up UI.
    // - descriptionMessage is what will be shown inside the pop-up window, is a string sufficent here?
    let informationTitle : String
    let descriptionMessage : String
    
    // Key set representing potential JS DOM targets
    let jsElementKeys : JSElementKeys
    
    // The specific key (resolved from `functionToCall + jsElementKeys`) to use in JS injection.
    let jsElementKey : String
    
    init(from decoder: any Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.functionToCall = try container.decode(FunctionToCall.self, forKey: .functionToCall)
            self.jsElementKeys = try container.decode(JSElementKeys.self, forKey: .jsElementKeys)
            self.websiteUrl = try container.decode(String.self, forKey: .websiteUrl)
            self.willNavigate = try container.decode(Bool.self, forKey: .willNavigate)

            // tillfällig tilldelning för att se om något saknas i db bara
            self.accessCalendar = try container.decodeIfPresent(Bool.self, forKey: .accessCalendar) ?? false
            self.informationTitle = try container.decodeIfPresent(String.self, forKey: .informationTitle) ?? "Ingen tillgänglig informations title"
            self.descriptionMessage = try container.decodeIfPresent(String.self, forKey: .descriptionMessage) ?? "Ingen tillgänglig informations förklaring"
            self.valueToInject = try container.decodeIfPresent(String.self, forKey: .valueToInject) ?? "Ingen tillgänglig string från DB att injecta"
            
            // Kan göras egna codingkeys
            //https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types
            
            self.extractFromUser = try container.decode(ExtractFromUser.self, forKey: .extractFromUser)
            guard let key =  self.functionToCall.getValue(jsKey: self.jsElementKeys) else {
                print("missing key in functionToCall so there was no key in jsElementKeys")
                fatalError("missing key in functionToCall ")
                // add a throw
            }
            self.jsElementKey = key
            
        } catch{
            print(error)
            throw error
        }
    }
}

