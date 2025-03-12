//
//  browsing_buddyApp.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import SwiftUI

@main
struct browsing_buddyApp: App {
    //användaren global
    @StateObject var userSession = UserSession()
    
    var body: some Scene {
        WindowGroup {
            /*ContentView()
                .environmentObject(userSession)*/
            ParentView()
                .environmentObject(userSession)
        }
    }
}
