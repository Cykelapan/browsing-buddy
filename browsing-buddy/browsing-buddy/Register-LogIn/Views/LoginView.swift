//
//  LoginView.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-13.
//



import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userSession: UserSession
    @Binding var path: NavigationPath
    @Binding var model: SetupModel
    @State private var errmsg = ""
    @State private var email: String = ""
    @State private var password: String = ""
    private let api = AzureFunctionsUser()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Logga in")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            Text(errmsg)
            TextField("Ange email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .padding(.horizontal)

            SecureField("Ange lösenord", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                Task {
                    await model.loginUser(input: AppUser(email: email , passwordApp: password), userSession: userSession)
                  
                   
                }
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

    private func login() async {
        //let newUser = UserProfile(username: email, email: "email@example.com", // bara test
            //password: password
        //)
        print("Logging")
        
       // userSession.currentUser = newUser
        //print("User registered: \(newUser)")
    }
}
