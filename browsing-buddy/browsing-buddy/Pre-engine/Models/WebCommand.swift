//
//  WebInteractions.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import Foundation


enum CommandType : String, Codable{
    case CLICK = "CLICK"
    case INSERT = "INSERT"
    case GET_INFORMATION = "GET_INFORMATION"
}

enum ParameterAction : Int, Codable{
    case NOTHING = 0
    case GET_USERNAME
    case GET_EMAIL
    case GET_PASSWORD
    case GET_FIRSTNAME
    case GET_LASTNAME
    case GET_FULLNAME
    
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
//Or open a small input box in a view to get that data
struct WebCommand : Codable{
    let commandType : CommandType
    let jsElementKey : String
    var jsInputParameters : [String]
    let parameterAction : ParameterAction
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commandType = try container.decode(CommandType.self, forKey: .commandType)
        self.jsElementKey = try container.decode(String.self, forKey: .jsElementKey)
        self.jsInputParameters = try container.decode([String].self, forKey: .jsInputParameters) ??  []
        self.parameterAction = try container.decode(ParameterAction.self, forKey: .parameterAction)
        guard let parameterFromUser = self.parameterAction.getValue() else {
            return
        }
        self.jsInputParameters.append(parameterFromUser)
    }
}

