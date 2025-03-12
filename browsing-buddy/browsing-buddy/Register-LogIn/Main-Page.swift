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
                    route: .registrera,
                    path: $path
                )
                .padding(.horizontal)

                NavigationButton(
                    text: "Logga in",
                    color: .green,
                    fontSize: 22,
                    route: .login,
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

struct Registrera: View {
    
    var body: some View {
        
        VStack {
            Text("Registrera dig")
                .font(.title)
                .padding()
        }
        .navigationTitle("Registrering")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct LoginView: View {
    @EnvironmentObject var userSession: UserSession
    @Binding var path: NavigationPath
    
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Logga in")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)

            TextField("Ange användarnamn", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("Ange lösenord", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                login()
                path.append(AppRoute.contentView)
            }) {
                Text("Logga in")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .font(.title3)
            }
            .padding(.horizontal)
            .padding(.top, 20)

            Spacer()
        }
        .navigationTitle("Logga in")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func login() {
        let newUser = UserProfile(
            username: username,
            email: "email@example.com", // bara test
            password: password
        )
        print("Logging")
        
        userSession.currentUser = newUser
        print("User registered: \(newUser)")
    }
}

