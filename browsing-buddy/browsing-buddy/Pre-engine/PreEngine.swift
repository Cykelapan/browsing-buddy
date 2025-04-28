//
//  PreEngine.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import Foundation
import SwiftUI
//DB connection
//Engine connection
//Button factory
//Initial state -> start webbrowser, buttons and so on //*[@id="topWrapper"]/header/div[1]/ul/li[3]/a

class PreEngine {
    static let shared = PreEngine()
    private let api = AzureFunctionsApi()
    @EnvironmentObject var userSession: UserSession
    //remember old state if something goes wrong?
    private var websiteName: String = ""
    private var stateDesc: String = ""
    private init() {}
    
    private func loggAction(button: UIButtonData, error: String? = nil) {
        DispatchQueue.global(qos: .background).async {
            let date = Date()
            let request = LoggerRequest(button: button, time: date.description, name: self.websiteName, state: self.stateDesc, error: error)
            Task {
                await self.api.send(request)
            }
        }
    }
    
    public func buttonAction(button: UIButtonData, webViewController: WebViewController, updateButtons: @escaping ([UIButtonData]) -> Void ) async {
        let request = NextWebstateRequest(body: button)
        let result = await api.send(request)
        //loggAction(button: button)
        switch result {
        case .success(let responseData):
            self.stateDesc = responseData.state
            self.websiteName = responseData.website
            //loggAction(button: button)
            
            webViewController.addActions(responseData.webCommands){
                updateButtons(responseData.uiButtons)
            }

        case .failure(let error):
            //TODO: find and backuplist when it do not work
            
            loggAction(button: button, error: error.localizedDescription)
            print("Error:", error.localizedDescription)
        }
    }
}

