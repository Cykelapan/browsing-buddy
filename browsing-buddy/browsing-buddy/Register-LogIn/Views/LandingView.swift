//
//  LandingPage.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-15.
//

import SwiftUI

struct LandingPage: View {
    @State private var setup = SetupModel()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 40) {
                Text("Välkommen till Browsing-Buddy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)

                NavigationButtonSetup(
                    text: "Registrera dig",
                    color: .blue,
                    fontSize: 22,
                    route: .registrera,
                    path: $path,
                    model: $setup
                )
                .padding(.horizontal)

                NavigationButtonSetup(
                    text: "Logga in",
                    color: .green,
                    fontSize: 22,
                    route: .login,
                    path: $path,
                    model: $setup
                )
                .padding(.horizontal)

                Spacer()
            }
            .navigationDestination(for: AppRouteSetup.self) { route in
                route.view(path: $path, model: $setup)
            }
        }
    }
}

#Preview {
    LandingPage()
}
