//
//  SettingsModel.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-29.
//

import Foundation
import SwiftUI

@Observable
class SettingsModel {
    var avalibleWebsites: [UIButtonData] =  []
    var fontSize: CGFloat = 15
    var textToSpeech : Bool = false
    var translation : Bool = false
    var lang = ["Svenska", "Finska", "Norska", "Danska"]
    private var selectedLang : String = "Svenska"
    private var api = AzureFunctionsApi()
    
    
    func getInitalStates(selectedFavorites: [UIButtonData]) async  {
        if (!avalibleWebsites.isEmpty) {return}
        let request = GetAllInitialWebstateRequest()
        let result = await api.send(request)
        switch result {
        case.success(let data):
            avalibleWebsites = data.filter { !selectedFavorites.contains($0) }
        case .failure(let err):
            print(err)
        }
    }
    
    func updateUserSession(){
        
    }
}
