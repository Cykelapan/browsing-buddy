//
//  RegisterRequest.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-25.
//

import Foundation

struct RegisterAppUser : Codable {
    let email : String
    let passwordApp: String
    
    let textSize : Int
    let language : String
    
}

struct RegisterRequest: ApiRequest {
    typealias RequestBody = AppUser
    typealias Response = UserData

    var endpoint: String { "register" }
    var method: HTTPMethod { .post }
    var body: AppUser?
    var requireAuth: Bool = false

    init(user: AppUser) {
        self.body = user
    }
}
