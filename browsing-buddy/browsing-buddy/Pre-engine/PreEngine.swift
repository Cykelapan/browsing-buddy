//
//  PreEngine.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import Foundation

//DB connection
//Engine connection
//Button factory
//Initial state -> start webbrowser, buttons and so on

class PreEngine {
    static let shared = PreEngine()
    private let api = AzureFunctionsApi()
    //remember old state if something goes wrong?
    //private let stateButtons = nil
    private init() {}
    
 
    public func buttonAction(button: UIButtonData, webViewController: WebViewController) async -> [UIButtonData] {
        //Get data based on button pressed, collect data and send it back into Engine and buttons
        //TODO: fix return type and try to make it somewhat safe
        let request = NextWebstateRequest(body: button)
        let result = await api.send(request)
        switch result {
            
        case .success(let responseData):
            await webViewController.addActions( responseData.webCommands)
            return responseData.uiButtons
            
        case .failure(let error):
            print(error)
            return []
        }
    }
}

