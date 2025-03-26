//
//  SettingsRequest.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-26.
//

import Foundation


struct GetAllInitialWebstateRequest : ApiRequest {
    typealias RequestBody = UIButtonData
    typealias Response = [UIButtonData]
    
    var endpoint: String { "initialWebstate" }
    var method: HTTPMethod { .get }
    var body: UIButtonData? = nil
    var requireAuth: Bool = false
    
}

// bygg på sen med vad som behövs
struct UserRequest: Codable {
    let userId: String
}


struct GetUserSettings : ApiRequest {
    typealias RequestBody = UserRequest
    typealias Response = UserSettings
    
    var endpoint: String { "getUserSettings" }
    var method: HTTPMethod { .post }
    var body: UserRequest?
    var requireAuth: Bool = false
    
}
struct BodyUserSettings : Codable {
    let textSize : Int
    let languageToUse : String
    let favoriteWebsites : [UIButtonData]
    let userId : String
}

struct SetUserSettings : ApiRequest {
    typealias RequestBody = BodyUserSettings
    typealias Response = UserSettings
    
    var endpoint: String { "setUserSettings" }
    var method: HTTPMethod { .post }
    var body: BodyUserSettings?
    var requireAuth: Bool = false
    
}
