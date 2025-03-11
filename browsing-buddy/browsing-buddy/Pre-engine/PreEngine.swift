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
    
    public func buttonAction(button: UIButtonData) {
        //Get data based on button pressed, collect data and send it back into Engine and buttons
        
    }
}

class GetMockData {
    
    public func getDataByKey(key: String){
        guard let fileUrl = Bundle.main.url(forResource: key, withExtension: "json") else {
            return
        }
        do {
            let data = try  Data(contentsOf: fileUrl)
            let feed = try JSONDecoder().decode(StateData.self, from: data)
            print(feed)
        } catch {
            print("Error: ", error.localizedDescription, error)
        }
        
    }
}

class DbConnection {
    
}
