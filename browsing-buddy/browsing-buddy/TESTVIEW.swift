//
//  TESTVIEW.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-12.
//

import SwiftUI



//För settings av användare
// Textstorlek, Färg?, Favoriter

struct TESTVIEW: View {
    @State private var fontSize: CGFloat = 15
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        VStack{
            LabeledContent("iOS Version", value: "2.2.1")
            Section("Notes Font Size \(Int(fontSize))") {
                Slider(value: $fontSize, in: 10...40, step: 1) {
                    Text("Point Size \(Int(fontSize))")
                }
            }
            
        }.frame(width: 234, alignment: .center)
        
    }
}

struct Registrera2: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var passwordMatch: Bool {
        !password.isEmpty && password == confirmPassword
    }
    func isValidEmailComplex(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    var body: some View {
        
        VStack {
            Text("Registrera dig")
                .font(.title)
                .padding()
            
            Text("Skriv in din email")
            TextField("Email", text: $email)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.bottom, 30)
                .keyboardType(.emailAddress)
                                
            Text(passwordMatch ? "Lösenord matchar" : "Skriv in ditt Lösenord")
            SecureField("Lösenord", text: $password)
                .background(RoundedRectangle(cornerRadius: 50)
                    .stroke(passwordMatch ? Color.green : Color.clear, lineWidth: 5))
            SecureField("Bekräfta Lösenord", text: $confirmPassword)
                .background(RoundedRectangle(cornerRadius: 50)
                    .stroke(passwordMatch ? Color.green : Color.clear, lineWidth: 5))
                    .padding(.bottom, 30)
            
            
            HStack {
                Button {
                    //gå tillbaka
                } label: {
                    Text("Avsluta")
                        .frame(maxWidth: .infinity)
                }.buttonStyle(.bordered)
                
                Button {
                    //aktivera registering
                } label: {
                    Text("Registera dig")
                        .frame(maxWidth: .infinity)
                }.buttonStyle(.borderedProminent)
            }.padding(.top)
        
        }
        .textFieldStyle(.roundedBorder)
        .padding()
        .background(Color.mint.gradient.opacity(0.7))
        .navigationTitle("Registrering")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    Registrera2()
}
