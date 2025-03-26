//
//  AzureFunctionsBase.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-25.
//

import Foundation


enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}
//Egena error meddelande
struct APIErrorResponse: Decodable {
    let error: String
}


enum NetworkError: Error, LocalizedError {
    case badURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case statusCode(Int)
    case custom(message: String)
    
    var errorDescription: String?{
        switch self {
        case .badURL: return "Invalid URL"
        case .requestFailed(let err): return "Request failed:  \(err.localizedDescription)"
        case .invalidResponse: return "Invalid response from server"
        case .decodingError(let err): return "Failed to decode: \(err.localizedDescription)"
        case .statusCode(let code): return "Server returned error code \(code)"
        case .custom(let message): return message
        }
    }
}

protocol ApiRequest {
    associatedtype RequestBody: Encodable
    associatedtype Response: Decodable
    
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var body: RequestBody? { get }
    var requireAuth: Bool { get }
}

class AzureFunctionsApi {
    private let baseURI: String = "https://5418-31-40-213-104.ngrok-free.app/api/"
    private var session: URLSession = URLSession.shared
    //Om token och entraID behövs sen
    private let tokenProvider:  () -> String? = { nil }
    
    func send<T: ApiRequest>(_ request: T) async -> Result<T.Response, NetworkError> {
        
        do {
            let urlRequest = try setRequest(requestSetup: request)
            let (data, response) = try await session.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                if let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                    return .failure(.custom(message: errorResponse.error))
                } else {
                    return .failure(.statusCode(httpResponse.statusCode))
                }
            }
            
            let decoded = try JSONDecoder().decode(T.Response.self, from: data)
            return .success(decoded)
            
        } catch let decodingError as DecodingError {
            return .failure(.decodingError(decodingError))
            
        } catch {
            return .failure(.requestFailed(error))
        }
    }
    
    private func setRequest<T: ApiRequest>(requestSetup: T) throws -> URLRequest {
        guard let url = URL(string: baseURI + requestSetup.endpoint) else {
            throw NetworkError.badURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestSetup.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = requestSetup.body {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }
        //Lägg till token på request
        if requestSetup.requireAuth, let token = tokenProvider() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return urlRequest
    }
}
