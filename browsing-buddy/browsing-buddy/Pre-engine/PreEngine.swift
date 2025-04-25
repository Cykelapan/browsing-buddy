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
//Initial state -> start webbrowser, buttons and so on

class PreEngine {
    static let shared = PreEngine()
    private let api = AzureFunctionsApi()
    @EnvironmentObject var userSession: UserSession
    //remember old state if something goes wrong?
    //private let stateButtons = nil
    private init() {}
    
    private func loggAction(button: UIButtonData) {
        DispatchQueue.global(qos: .background).async {
            let date = Date()
            let request = LoggerRequest(button: button, time: date.description)
            Task {
                await self.api.send(request)
            }
        }
    }
    
    public func buttonAction(button: UIButtonData, webViewController: WebViewController, updateButtons: @escaping ([UIButtonData]) -> Void ) async {
        let request = NextWebstateRequest(body: button)
        let result = await api.send(request)
        loggAction(button: button)
        switch result {
        case .success(let responseData):
            webViewController.addActions(responseData.webCommands){
                updateButtons(responseData.uiButtons)
            }

        case .failure(let error):
            //TODO: find and backuplist when it do not work
            print("Error:", error.localizedDescription)
        }
    }
}

