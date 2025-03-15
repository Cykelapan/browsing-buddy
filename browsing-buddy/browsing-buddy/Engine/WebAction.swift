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
    //let cssSelector : String?
}

/*
 Kan justera den mer och göra den mindre
 
 Men siktar på att vi ska kunna läsa den sen i jsonFilerna
 
 */
struct WebAction : Codable{
    //function to call, will also take out the key from JSElementKeys
    let websiteUrl : String //bara url med path
    let functionToCall : FunctionToCall
    let extractFromUser : ExtractFromUser
    let accessCalendar : Bool?
    let informationTitle : String
    // Gör om det till ett enum på en gång
    
    
   
    let willNavigate : Bool
    let jsElementKeys : JSElementKeys
    //Dont need keys for this
    let descriptionMessage : String
    let jsElementKey : String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.functionToCall = try container.decode(FunctionToCall.self, forKey: .functionToCall)
        self.jsElementKeys = try container.decode(JSElementKeys.self, forKey: .jsElementKeys)
        
        self.accessCalendar = try container.decode(Bool?.self, forKey: .accessCalendar)
        self.willNavigate = try container.decode(Bool.self, forKey: .willNavigate)
    
        self.informationTitle = try container.decode(String?.self, forKey: .informationTitle) ?? "Information"
        self.websiteUrl = try container.decode(String.self, forKey: .websiteUrl)
        self.descriptionMessage = try container.decodeIfPresent(String.self, forKey: .descriptionMessage) ?? "Information"
        
        // Kan göras egna codingkeys
        //https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types
        
        self.extractFromUser = try container.decode(ExtractFromUser.self, forKey: .extractFromUser)
        guard let key =  self.functionToCall.getValue(jsKey: self.jsElementKeys) else {
            fatalError("missing key")
        }
        self.jsElementKey = key
        //TODO: fixa så det väljer nyckel baserat på det som ska användas och blir säkert, är för lätt att skriva fel med strings
    }
}

