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
    private let mockData = GetMockData()
    private let ApiState = AzureFunctionsWebstate()
    private init() {}
    
    
    public func test(){
        mockData.getDataByKey(key: "login_state")
    }
    
    
    //Connection to webController
    private func sendButtonListToButtonFactory(buttons: [UIButtonData]){
        
    }
    //Connection to
    private func sendWebCommandsToEngine(commands: [String]){
        //send the webcommands
    }
    
    public func buttonAction(button: UIButtonData, webViewController: WebViewController?) async {
        //Get data based on button pressed, collect data and send it back into Engine and buttons
        let result = await ApiState.getWebstate(uiButton: button)
        switch result {
        case .failiure:
            return
        case .sucsses(let state):
            //webViewController?.addActions(state.webCommands)
            //return state.uiButtons
            return
        }
        
    }
}

class GetMockData {
    
    public func getDataByKey(key: String){
        guard let fileUrl = Bundle.main.url(forResource: key, withExtension: "json") else {
            return
        }
        do {
            let data = try  Data(contentsOf: fileUrl)
            let feed = try JSONDecoder().decode(WebState.self, from: data)
            print(feed)
        } catch {
            print("Error: ", error.localizedDescription, error)
        }
        
    }
}

class DbConnection {
    
}
