//
//  UserSettingsView.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-04-12.
//

import SwiftUI

struct UserSettingsView: View {
    @EnvironmentObject var router: AppRouter
    var body: some View {
        Text("Hello, UserSettingsView!")
        Button("Back") {
            router.navigateBack()
            
        }
    }
}


#Preview {
    UserSettingsView()
}
