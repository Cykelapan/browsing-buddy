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
    @StateObject var userSession = UserSession(currentUser: UserProfile(userId: "", email: "", password: ""))
    
    var body: some Scene {
        WindowGroup {
            /*ContentView()
                .environmentObject(userSession)*/
            /*ParentView()
                .environmentObject(userSession)*/
            if userSession.currentUser.userId == ""{
                LandingPage()
            } else {
                //TODO: contentView and that navigation
                ContentView()
            }
        }.environmentObject(userSession)
    }
}
