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
    let websiteName: String
    let state: String
    let error: String?
}
struct LoggerRequestResponse: Codable {
    let _id : String
    let buttonPressed : UIButtonData
    let time : String
    let websiteName: String
    let state: String
    
    
}

struct LoggerRequest: ApiRequest {
    typealias RequestBody = LoggerRequestBody
    typealias Response = LoggerRequestResponse

    var endpoint: String { "setLoggerInfo" }
    var method: HTTPMethod { .post }
    var body: LoggerRequestBody?
    var requireAuth: Bool = false

    init(button: UIButtonData, time: String, name: String, state: String, error: String? = nil) {
        self.body = LoggerRequestBody(buttonPressed: button, time: time, websiteName: name, state: state, error: error)
    }
}
