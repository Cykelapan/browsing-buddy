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
    @StateObject var userSession = UserSession(currentUser: createUserProfile(userId: "", email: "", password: ""))
    @StateObject private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            if userSession.currentUser.userId == ""{
                LandingPage()
            } else {
                //TODO: contentView and that navigation
                MainView()
            }
        }.environmentObject(userSession).environmentObject(router)
    }
}
