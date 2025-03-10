//
//  browsing_buddyApp.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import SwiftUI

@main
struct browsing_buddyApp: App {
    var body: some Scene {
        WindowGroup {
            //ButtonView()
            Text("Hello, MongoDB!")
                       .onAppear {
                           readDocumentsFromMongoDB()  // Call your function here
                       }
        }
    }
}
