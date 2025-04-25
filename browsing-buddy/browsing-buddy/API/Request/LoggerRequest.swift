//
//  LoggerRequest.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-04-25.
//

import Foundation


struct LoggerRequestBody: Codable {
    let buttonPressed : UIButtonData
    let time : String
    
}
struct LoggerRequestResponse: Codable {
    let _id : String
    let buttonPressed : UIButtonData
    let time : String
    
}

struct LoggerRequest: ApiRequest {
    typealias RequestBody = LoggerRequestBody
    typealias Response = LoggerRequestResponse

    var endpoint: String { "setLoggerInfo" }
    var method: HTTPMethod { .post }
    var body: LoggerRequestBody?
    var requireAuth: Bool = false

    init(button: UIButtonData, time: String) {
        self.body = LoggerRequestBody(buttonPressed: button, time: time)
    }
}
