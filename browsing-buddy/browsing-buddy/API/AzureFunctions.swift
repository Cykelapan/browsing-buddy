//
//  AzureFunctions.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-12.
//
import Foundation

enum CRUD{
    case CREATE
    case REMOVE
    case UPDATE
    case DELETE
}

enum HTTPMETHOD : String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

struct StateKey: Codable {
    let webStateKey : String
}



struct PasswordManager : Codable {
    let website : String
    let password : String
    let username : String
    let userId : String
}


class AzureFunctions {
    //Kan användas nu lokalt nu under utveckligen, sen när azure har det blir det fråga om user session och koppla det så
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
    //Kolla responsen
    private func okResponse(){
        
    }
    public func getWebstate(webStateKey: StateKey) async{
        guard let url = URL(string: baseURI + "webstate") else { return }
        
        do {
            var request = setWebsiteHeader(inUrl: url, httpMethod: "POST")
            request.httpBody = try encodeToJSON(webStateKey)
            
            let (data, response ) = try await URLSession.shared.data(for: request)
            let convertdata = try JSONDecoder().decode(WebState.self, from: data)
            print(convertdata)
            
        } catch {
            print(error)
        }
        
    }
    public func addToPasswordManager(input: PasswordManager) async{
        guard let url = URL(string: baseURI + "addObjectPasswordManager") else { return }
        
        do {
            var request = setWebsiteHeader(inUrl: url, httpMethod: "POST")
            request.httpBody = try encodeToJSON(input)
            
            let (data, _ ) = try await URLSession.shared.data(for: request)
            let convertdata = try JSONDecoder().decode(PasswordManager.self, from: data)
            print(convertdata)
            
        } catch {
            print(error)
        }
        
    }
    
    public func updateObjectPasswordManager(input: PasswordManager) async{
        guard let url = URL(string: baseURI + "updateObjectPasswordManager") else { return }
        return await objectToPasswordManager(inUrl: url, method: "PATCH", input: input)
        
    }
    private func objectToPasswordManager(inUrl: URL, method:String, input: PasswordManager ) async {
        do {
            var request = setWebsiteHeader(inUrl: inUrl, httpMethod: method)
            request.httpBody = try encodeToJSON(input)
            
            let (data, _ ) = try await URLSession.shared.data(for: request)
            let convertdata = try JSONDecoder().decode(PasswordManager.self, from: data)
            print(convertdata)
            
        } catch {
            print(error)
        }
    }
    public func deleteObjectPasswordManager(input: PasswordManager) async{
        guard let url = URL(string: baseURI + "deleteObjectPasswordManager") else { return }
         return await objectToPasswordManager(inUrl: url, method: "POST", input: input)
        
    }
    
    public func getAllWebstate() async{
        guard let url = URL(string: baseURI + "getwebstate") else { return }
        
        do {
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
           
            let (data, response) = try await URLSession.shared.data(for: request)
            
            //let ss = try JSONSerialization.data(withJSONObject: data)
            //print(ss)
            print(data)
            print(response)
            
        } catch {
            print(error)
        }
        
    }
    
}


func testApi()async{
    let api = AzureFunctions()
    let d = StateKey(webStateKey: "67d042419b97d88fcfb71237")
    
    await api.getWebstate(webStateKey: d)
    //await api.getAllWebstate()
    
}
