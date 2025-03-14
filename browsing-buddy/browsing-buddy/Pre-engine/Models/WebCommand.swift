//
//  WebInteractions.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import Foundation

enum ElementKeyToUse : String, Codable{
    case ELEMENT_ID = "elementID" // document.getByid()
    case X_PATH = "xPath" //document.evaluate() -> //
    case CLASS_NAME = "className" // document.getElementsByClassName(className);
    case CSS_SELECTOR = "cssSelector" // document.querySelector()
    case NO_KEY = "noKeyNeeded"
}


enum FunctionToCall : String, Codable {
    case INPUT_REQUEST = "INPUT_REQUEST"//no key just input
    case SHOW_MESSAGE = "SHOW_MESSAGE" //no key just show
    case SHOW_EXTRACTED_MESSAGE = "SHOW_EXTRACTED_MESSAGE"
    case Extract_Message = "Extract_Message" //xPath
    case Insert_Element = "Insert_Element" //xPath
    case Insert_Element_Class = "Insert_Element_Class" //className
    case Extract_List_By_Xpath = "Extract_List_By_Xpath" //xpath
    case A = "A" // want url
    case D = "D" // className
    case G = "G" // xPath
    
    func getValue(jsKey: JSElementKeys) -> String?{
        switch self {
        case .INPUT_REQUEST, .SHOW_MESSAGE, .SHOW_EXTRACTED_MESSAGE ,.A:
            return "Kvittar"
            
        case .Insert_Element_Class, .D:
            return jsKey.classPath
            
        case .Extract_Message, .Insert_Element, .Extract_List_By_Xpath, .G:
            return jsKey.xPath
            
        }
    }
}

enum ExtractFromUser : Int, Codable{
    case NOTHING = 1
    case GET_USERNAME
    case GET_EMAIL
    case GET_PASSWORD
    case GET_FIRSTNAME
    case GET_LASTNAME
    case GET_FULLNAME
    
    //Koppla till användarens data
    func getValue() -> String {
        switch self {
        case .NOTHING:
            return ""
        case .GET_USERNAME:
            return "username"
        case .GET_EMAIL:
            return "email"
        case .GET_PASSWORD:
            return "password"
        case .GET_FIRSTNAME:
            return "firstname"
        case .GET_LASTNAME:
            return "lastname"
        case .GET_FULLNAME:
            return "fullname"
        }
    }
}

//Parameter is user specific and need to be collected?
// 1. Statiska parametrar i db om det finns, 2. från användarens data, 3. Custom input when you are there
//Or open a small input box in a view to get that data
//Hur många in parametrar behövs egentligen? och hur ska det användas i engine?

//Lägg till elementType, elementKey enbart en string
struct WebCommand : Codable{
    let functionToCall : FunctionToCall
    let extractFromUser : String
    let informationTitle : String?
    
    let willNavigate : Bool
    let websiteUrl : String //bara url med path
    
    let jsElementKeys : JSElementKeys
    let jsElementKey : String
    var jsInputValue : String?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.functionToCall = try container.decode(FunctionToCall.self, forKey: .functionToCall)
        self.jsElementKeys = try container.decode(JSElementKeys.self, forKey: .jsElementKeys)
        self.jsInputValue = try container.decode(String.self, forKey: .jsInputValue)
        self.willNavigate = try container.decode(Bool.self, forKey: .willNavigate)
        let extract = try container.decode(ExtractFromUser.self, forKey: .extractFromUser)
        self.informationTitle = try container.decode(String?.self, forKey: .informationTitle)
        self.websiteUrl = try container.decode(String.self, forKey: .websiteUrl)
        
        self.jsInputValue = extract.getValue() ?? ""
        self.extractFromUser = extract.getValue()
        guard let key =  self.functionToCall.getValue(jsKey: self.jsElementKeys) else {
            fatalError("missing key")
        }
        self.jsElementKey = key
        //TODO: fixa så det väljer nyckel baserat på det som ska användas
    }
}
struct JSElementKeys: Codable {
    let className : String?
    let classPath : String?
    let elementId : String?
    let elementTag : String?
    let cssSelector : String?
    let xPath : String?
    //let cssSelector : String?
}
