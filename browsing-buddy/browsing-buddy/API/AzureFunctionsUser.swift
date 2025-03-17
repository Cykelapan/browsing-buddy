//
//  AzureFunctionsUser.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-13.
//

import Foundation

struct AppUser : Codable{
    let email : String
    let passwordApp: String
}

struct RegistrationOkResponse : Codable{
    let acknowledged : Bool
    let insertedId : String
}

enum ResponseRegistrationLogin {
    case sucssess(UserProfile)
    case failuer(String)
}

class AzureFunctionsUser {
    let baseURI = "https://5e4a-31-40-213-50.ngrok-free.app/api/"
    
    private func encodeToJSON<T:Codable>(_ object: T) throws -> Data {
        return try JSONEncoder().encode(object)
    }
    
    private func setWebsiteHeader(inUrl: URL, httpMethod: String) -> URLRequest {
        var req = URLRequest(url: inUrl)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = httpMethod
        return req
    }
    
    public func userLogin(input: AppUser) async  -> ResponseRegistrationLogin {
        guard let url = URL(string: baseURI + "login") else { return ResponseRegistrationLogin.failuer("BAD URL") }
        
        do {
            var request = setWebsiteHeader(inUrl: url, httpMethod: "POST")
            request.httpBody = try encodeToJSON(input)
            
            let (data, response ) = try await URLSession.shared.data(for: request)
            guard let isResponse = (response as? HTTPURLResponse) else {
                return ResponseRegistrationLogin.failuer("BAD response")
            }
            
            if (200...299).contains(isResponse.statusCode) {
                let convertdata = try JSONDecoder().decode(UserData.self, from: data)
                
                return ResponseRegistrationLogin.sucssess(UserProfile(userId: convertdata._id, email: convertdata.email, password: convertdata.passwordApp))
            }
          
          
            return ResponseRegistrationLogin.failuer("Fel")
        } catch {
            return ResponseRegistrationLogin.failuer(error.localizedDescription)
            
        }
    }
    
    public func userRegister(input: AppUser) async -> ResponseRegistrationLogin {
        guard let url = URL(string: baseURI + "registration") else { return ResponseRegistrationLogin.failuer("BAD URL")}
        
        do {
            var request = setWebsiteHeader(inUrl: url, httpMethod: "POST")
            request.httpBody = try encodeToJSON(input)
            
            let (data, response ) = try await URLSession.shared.data(for: request)
            
            guard let isResponse = (response as? HTTPURLResponse) else {
                return ResponseRegistrationLogin.failuer("BAD RESPONSE")
            }
            print(isResponse)
            if (200...299).contains(isResponse.statusCode) {
                let convertdata = try JSONDecoder().decode(RegistrationOkResponse.self, from: data)
                print(convertdata)
                return ResponseRegistrationLogin.sucssess(UserProfile(userId: convertdata.insertedId, email: input.email, password: input.passwordApp))
            }
            
            let ss = try JSONSerialization.jsonObject(with: data)
            //let convertdata = try JSONDecoder().decode(AppUser.self, from: data)
            print(ss)
            return ResponseRegistrationLogin.failuer("FEL")
        } catch {
            print(error)
            return ResponseRegistrationLogin.failuer(error.localizedDescription)
        }
    }
    
}
