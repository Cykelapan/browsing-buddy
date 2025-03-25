//
//  NextWebstateRequest.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-25.
//

import Foundation


struct NextWebstateRequest : ApiRequest {
    typealias RequestBody = UIButtonData
    typealias Response = WebState
    
    var endpoint: String { "webstate" }
    var method: HTTPMethod { .post }
    var body: UIButtonData?
    var requireAuth: Bool = false
    
}
