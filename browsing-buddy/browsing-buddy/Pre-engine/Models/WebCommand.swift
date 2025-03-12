//
//  WebInteractions.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import Foundation


enum CommandType : String, Codable{
    case CLICK = "click"
    case INSERT = "insert"
    case USER_INSERT = "userInsert"
    case GET_INFORMATION = "getinformation"
}

enum ElementType : String, Codable{
    case CLASS_PATH = "classPath"
    case ELEMENT_ID = "elementID"
    case X_PATH = "xPath"
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
    func getValue() -> String? {
        switch self {
        case .NOTHING:
            return nil
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
    let commandType : CommandType
    let jsElementKeys : JSElementKeys
    var jsInputParameters : [String]
    let parameterAction : ParameterAction
    let willNavigate : Bool
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commandType = try container.decode(CommandType.self, forKey: .commandType)
        self.jsElementKeys = try container.decode(JSElementKeys.self, forKey: .jsElementKeys)
        self.jsInputParameters = try container.decode([String].self, forKey: .jsInputParameters)
        self.willNavigate = try container.decode(Bool.self, forKey: .willNavigate)
        self.parameterAction = try container.decode(ParameterAction.self, forKey: .parameterAction)
        guard let parameterFromUser = self.parameterAction.getValue() else {
            return
        }
        self.jsInputParameters.append(parameterFromUser)
    }
}
struct JSElementKeys: Codable {
    let classPath : String?
    let elementId : String?
    let elementTag : String?
    let value : String?
    let xPath : String?
}
