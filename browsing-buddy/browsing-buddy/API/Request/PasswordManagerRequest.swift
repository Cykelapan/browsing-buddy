//
//  PasswordManagerRequest.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-04-25.
//

import Foundation


struct PasswordManagerSet: Codable {
    let websiteName: String
    let websiteUrl: String
    let username: String
    let password: String
    let userId: String
}

struct PasswordManager: Codable {
    let _id: String
    let websiteName: String
    let websiteUrl: String
    let username: String
    let password: String
    let userId: String
}

struct PasswordManagerRequest: ApiRequest {
    typealias RequestBody = PasswordManagerSet
    typealias Response = PasswordManager

    var endpoint: String { "addObjectPasswordManager" }
    var method: HTTPMethod { .post }
    var body: PasswordManagerSet?
    var requireAuth: Bool = false

    init(user: PasswordManagerSet) {
        self.body = user
    }
}
