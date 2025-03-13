//
//  AzureFunctionsWebstate.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-13.
//

import Foundation

enum WebstateResponse{
    case sucsses(WebState)
    case failiure(String)
}

class AzureFunctionsWebstate{
    let baseURI = "https://bd12-193-11-7-251.ngrok-free.app/api/"
    private func encodeToJSON<T:Codable>(_ object: T) throws -> Data {
        return try JSONEncoder().encode(object)
    }
    
    private func decodeFromJSON<T:Codable>(_ jsonData: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: jsonData)
    }
    
    private func setWebsiteHeader(inUrl: URL, httpMethod: String) -> URLRequest {
        var req = URLRequest(url: inUrl)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = httpMethod
        return req
    }
    
    public func getWebstate(uiButton: UIButtonData) async -> WebstateResponse{
        guard let url = URL(string: baseURI + "webstate") else { return WebstateResponse.failiure("BAD URL")}
        
        do {
            var request = setWebsiteHeader(inUrl: url, httpMethod: "POST")
            request.httpBody = try encodeToJSON(uiButton)
            
            let (data, response ) = try await URLSession.shared.data(for: request)
            let isResponse = (response as! HTTPURLResponse)
            
            if ((300...500).contains(isResponse.statusCode)) { return WebstateResponse.failiure("Err") }
            
            let convertdata = try JSONDecoder().decode(WebState.self, from: data)
            return WebstateResponse.sucsses(convertdata)
            
        } catch {
            return WebstateResponse.failiure(error.localizedDescription)
        }
        
    }
}
