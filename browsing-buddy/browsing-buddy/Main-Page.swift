//
//  Main-Page.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-12.
//

import SwiftUI

struct ParentView: View {
    @State private var path = NavigationPath()
    @EnvironmentObject var userSession: UserSession
    
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 40) {
                Text("Välkomment till Browsing-Buddy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 50)

                NavigationButton(
                    text: "Registrera dig",
                    color: .blue,
                    fontSize: 22,
                    route: .contentView,
                    path: $path
                )
                .padding(.horizontal)

                NavigationButton(
                    text: "Logga in",
                    color: .green,
                    fontSize: 22,
                    route: .contentView,
                    path: $path
                )
                .padding(.horizontal)

                Spacer()
            }
            .navigationDestination(for: AppRoute.self) { route in
                route.view(path: $path)
            }
        }
    }
}

#Preview {
    ParentView()
}






