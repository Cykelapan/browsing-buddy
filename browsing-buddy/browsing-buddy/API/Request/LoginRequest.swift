//
//  LoginRequest.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-25.
//

import Foundation

struct AppUser : Codable{
    let email : String
    let passwordApp: String
}

struct LoginRequest: ApiRequest {
    typealias RequestBody = AppUser
    typealias Response = UserData

    var endpoint: String { "login" }
    var method: HTTPMethod { .post }
    var body: AppUser?
    var requireAuth: Bool = false

    init(user: AppUser) {
        self.body = user
    }
}
