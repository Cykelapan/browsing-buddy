//
//  ExtractFromUser.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-14.
//

import Foundation


enum ExtractFromUser : String, Codable{
    case NOTHING = "NOTHING"
    case GET_USERNAME = "GET_USERNAME"
    case GET_EMAIL = "GET_EMAIL"
    case GET_PASSWORD = "GET_PASSWORD"
    case GET_FIRSTNAME = "GET_FIRSTNAME"
    case GET_LASTNAME = "GET_LASTNAME"
    case GET_FULLNAME = "GET_FULLNAME"
    
    //Koppla till användarens data
    func getValue(session: UserSession) -> String {
        switch self {
        case .NOTHING:
            return ""
        case .GET_USERNAME:
            return "username"
        case .GET_EMAIL:
            return session.currentUser.email
        case .GET_PASSWORD:
            return session.currentUser.password
        case .GET_FIRSTNAME:
            return "firstname"
        case .GET_LASTNAME:
            return "lastname"
        case .GET_FULLNAME:
            return "fullname"
        }
    }
}
