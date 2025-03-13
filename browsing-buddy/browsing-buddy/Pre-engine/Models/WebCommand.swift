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
}

enum FunctionToCall : String, Codable {
    case INPUT_REQUEST = "INPUT_MESSAGE"
    case SHOW_MESSAGE = "SHOW_MESSAGE"
    case CLICK_BUTTON = "CLICK_BUTTON"
    case A = "A"
    case B = "B"
    case C = "C"
    case D = "D"
    case E = "E"
    case F = "F"
    case G = "G"
}

enum ParameterAction : Int, Codable{
    case NOTHING = 0
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
    let jsElementKeys : JSElementKeys
    let jsElementKey : String
    var jsInputParameter : String?
    let parameterAction : ParameterAction
    let willNavigate : Bool
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.functionToCall = try container.decode(FunctionToCall.self, forKey: .functionToCall)
        self.jsElementKeys = try container.decode(JSElementKeys.self, forKey: .jsElementKeys)
        self.jsInputParameter = try container.decode(String?.self, forKey: .jsInputParameter)
        self.willNavigate = try container.decode(Bool.self, forKey: .willNavigate)
        self.parameterAction = try container.decode(ParameterAction.self, forKey: .parameterAction)
        self.jsElementKey = ""
        //TODO: fixa så det väljer nyckel baserat på det som ska användas
    }
}
struct JSElementKeys: Codable {
    let className : String?
    let elementId : String?
    let elementTag : String?
    let cssSelector : String?
    let xPath : String?
}
