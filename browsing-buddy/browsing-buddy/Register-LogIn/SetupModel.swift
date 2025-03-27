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
    var errorMessage: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    
    public func cleanData() {
        errorMessage = ""
        email = ""
        password = ""
        confirmPassword = ""
    }
    private func getUserSettings(input: UserRequest) async -> UserSettings?{
        let requestSettings = GetUserSettings(body: input)
        let response = await api.send(requestSettings)
        
        switch response {
        case .success(let responseData):
            return responseData
        case .failure(let error):
            print(error)
            return nil
        }
    }
    
    public func loginUser(userSession: UserSession) async {
        let request = LoginRequest(user: AppUser(email: email, passwordApp: password))
        let response = await api.send(request)
        
        switch response {
        case .success(let respsonseData):
            /*guard let settings = await getUserSettings(input: UserRequest(userId: respsonseData._id)) else {
                return userSession.currentUser = createUserProfileFrom(userData: respsonseData)
            }
            return userSession.currentUser = createUserProfileFromData(userData: respsonseData, userSettings: settings)*/
            //Set up the settings in the user session
            return userSession.currentUser = createUserProfileFrom(userData: respsonseData)
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    
    public func registerUser(userSession: UserSession) async   {
        let request = RegisterRequest(user: AppUser(email: email, passwordApp: confirmPassword))
        let response = await api.send(request)
        switch response {
        case .success(let respsonseData):
            return userSession.currentUser = createUserProfileFrom(userData: respsonseData)
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
    /*
    public func getAllWebsite() async {
        let request = GetAllInitialWebstateRequest()
        let result = await api.send(request)
        switch result {
        case.success(let data):
            //avalibleWebsites = data
        case .failure(let err):
            print(err)
        }
    }
     */
}
