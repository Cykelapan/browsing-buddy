//
//  SetupModel.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-13.
//

import Foundation
import Observation
//Till senare att fixa kopplingar mellan api, alla variabler och usersession
@Observable
@MainActor
class SetupModel  {
    private let api = AzureFunctionsApi()
    var errorMessage = ""
    var email: String = ""
    var password: String = ""
    
    public func loginUser(userSession: UserSession) async {
        
        let request = LoginRequest(user: AppUser(email: email, passwordApp: password))
        let response = await api.send(request)
        
        switch response {
        case .success(let respsonseData):
            userSession.currentUser = UserProfile(userId: respsonseData._id, email: respsonseData.email, password: respsonseData.passwordApp)
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    //TODO: uppdater så den kan ta in en hel form med data när den registeras
    public func registerUser(input: AppUser, userSession: UserSession) async   {
        let request = RegisterRequest(user: input)
        let response = await api.send(request)
        switch response {
        case .success(let respsonseData):
            userSession.currentUser = UserProfile(userId: respsonseData._id, email: respsonseData.email, password: respsonseData.passwordApp)
        case .failure(let err):
            print(err)
            
        }
    }
}
