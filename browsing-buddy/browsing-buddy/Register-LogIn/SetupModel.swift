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
    private let UserApi = AzureFunctionsUser()
    
    
    
    public func loginUser(input: AppUser, userSession: UserSession) async -> ResponseRegistrationLogin {
        let res = await UserApi.userLogin(input: input)
        switch res {
        case .sucssess(let userData):
            //TODO: update userSession to close the setUpviews and enter contents view with a bool
            userSession.currentUser = UserProfile(userId: userData.userId, email: userData.email, password: userData.password)
                
            
        
            
        case .failuer(let msg):
            print(msg)
            
        }
        return res
    }
    //TODO: uppdater så den kan ta in en hel form med data när den registeras
    public func registerUser(input: AppUser, userSession: UserSession) async   {
        let res = await UserApi.userRegister(input: input)
        switch res {
        case .sucssess(let userData):
            //TODO: update userSession to close the setUpviews and enter contents view with a bool
            userSession.currentUser = UserProfile(userId: userData.userId, email: userData.email, password: userData.password)
        
            
        case .failuer(let msg):
            print(msg)
            
        }
        
       
    }
}
