//
//  ExtractFromUser.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-14.
//

import Foundation


enum ExtractFromUser : String, Codable{
    case NOTHING
    case GET_USERNAME = "GET_USERNAME"
    case GET_EMAIL = "GET_EMAIL"
    case GET_PASSWORD = "GET_PASSWORD"
    case GET_FIRSTNAME = "GET_FIRSTNAME"
    case GET_LASTNAME = "GET_LASTNAME"
    case GET_FULLNAME = "GET_FULLNAME"
    case GET_USER_AGE = "GET_USER_AGE"
    case GET_USER_INPUT = "GET_USER_INPUT"
    
    //Koppla till användarens data
    func getValue(session: UserSession) -> String {
        switch self {
        case .NOTHING:
            return "1"
        case .GET_USERNAME:
            return "Värnamo station"
        case .GET_EMAIL:
        //mail och inlogg till figma behöver vara här
            return session.currentUser.email
        case .GET_PASSWORD:
            return session.currentUser.password
        case .GET_FIRSTNAME:
            return "Jönköping"
        case .GET_LASTNAME:
            return "Stockholm"
        case .GET_FULLNAME:
            return "2020-08-16"
        case .GET_USER_AGE:
            return "75"
        case .GET_USER_INPUT:
            return session.userInput
        }
    }
}
