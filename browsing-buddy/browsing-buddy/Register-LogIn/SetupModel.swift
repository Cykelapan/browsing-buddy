//
//  SetupModel.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-13.
//

import Foundation

//Till senare att fixa kopplingar mellan api, alla variabler och usersession 
class SetupModel : Observable {
    private let UserApi = AzureFunctionsUser()
    
    
    
    public func loginUser(input: AppUser) async -> ResponseRegistrationLogin {
        return await UserApi.userLogin(input: input)
    }
    
    public func registerUser(input: AppUser) async -> ResponseRegistrationLogin {
        return await UserApi.userRegister(input: input)
    }
}
