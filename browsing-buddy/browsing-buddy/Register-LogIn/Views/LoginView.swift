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
 
    var body: some View {
        VStack(spacing: 20) {
            Text("Logga in")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            Text(model.errorMessage)
            TextField("Ange email", text: $model.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .padding(.horizontal)

            SecureField("Ange lösenord", text: $model.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                Task {
                    await model.loginUser(userSession: userSession)
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

            Button(action: {
                Task {
                    userSession.currentUser = UserProfile(userId: "respsonseData._id", email: "aa@aa.aa", password: "aa")
                  
                   
                }
            }) {
                Text("Dev login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .font(.title3)
            }
            .padding(.horizontal)
            .padding(.top, 20)
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
