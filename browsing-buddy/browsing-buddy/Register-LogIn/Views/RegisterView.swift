//
//  RegisterView.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-13.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var userSession: UserSession
    @Binding var path: NavigationPath
    @Binding var model: SetupModel
    
    var passwordMatch: Bool {
        !model.password.isEmpty && model.password == model.confirmPassword
    }

    var isValidEmail: Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: model.email)
    }
    
    var body: some View {
        VStack {
            Text("Registrera dig")
                .font(.title)
                .padding()
            
            Text("Skriv in din email")
            TextField("Email", text: $model.email)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.bottom, 30)
                .keyboardType(.emailAddress)
            
            Text(passwordMatch ? "Lösenord matchar" : "Skriv in ditt Lösenord")
            SecureField("Lösenord", text: $model.password)
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(passwordMatch ? Color.green : Color.clear, lineWidth: 5))
            SecureField("Bekräfta Lösenord", text: $model.confirmPassword)
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(passwordMatch ? Color.green : Color.clear, lineWidth: 5))
            
            if (!model.errorMessage.isEmpty) {Text(model.errorMessage).font(.caption)}
            Button {
                Task {
                    await model.registerUser(userSession: userSession)
                }
            } label: {
                Text("Registera dig")
                    .frame(maxWidth: .infinity)
            }.buttonStyle(.borderedProminent)
                .disabled(!isValidEmail && passwordMatch)
        }
        .textFieldStyle(.roundedBorder)
        .padding()
        .onAppear(perform: {model.cleanData()})
        .navigationTitle("Registrering")
        .navigationBarTitleDisplayMode(.inline)
    }
}
