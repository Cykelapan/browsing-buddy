//
//  TESTVIEW.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-12.
//

import SwiftUI
import Observation
@Observable
class AccountsPasswordManager: Identifiable {
    var id = UUID()
    var websiteName : String
    var websiteUrl : String
    var username : String
    var password : String
    init(id: UUID = UUID(), websiteName: String, websiteUrl: String, username: String, password: String) {
        self.id = id
        self.websiteName = websiteName
        self.websiteUrl = websiteUrl
        self.username = username
        self.password = password
    }
}

//För settings av användare
// Textstorlek, Färg?, Favoriter
//https://www.swiftanytime.com/blog/form-in-swiftui
struct TESTVIEW: View {
    @State private var fontSize: CGFloat = 15
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var date = Date()
    @State private var textToSpeech : Bool = false
    var lang = ["Svenska", "Finska", "Norska", "Danska"]
    @State private var selectedLang : String = "Svenska"
    @State private var singleSelectionAccounts: UUID? = nil
    
    @State var accounts = [
        AccountsPasswordManager(websiteName: "1177.se", websiteUrl: "https://1177.se", username: "user1177", password: "p@ssw0rd1234"),
        AccountsPasswordManager(websiteName: "Figma.com", websiteUrl: "https://www.figma.com", username: "figmaUser2025", password: "figmaPass@567"),
        AccountsPasswordManager(websiteName: "jlt.se", websiteUrl: "https://www.jlt.se", username: "jltUser007", password: "jltSecure!2025")
    ]
    
    var body: some View {
        NavigationStack {
            VStack{
                Form{
                    Section("Personligt") {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                        
                        
                        DatePicker(
                            "Födelsedatum",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                    }
                    Section("Kopplade konton") {
                        AccountListView(accounts: $accounts)
                    }
                    
                    Section("Tecken strolek \(Int(fontSize))") {
                        Slider(value: $fontSize, in: 15...40, step: 1) {
                            Text("Point Size \(Int(fontSize))")
                        }
                        Text("Example på hur texten blir").font(.system(size: fontSize))
                    }
                    Section("OTHER"){
                        Toggle("Uppläsning av text", isOn: $textToSpeech)
                        HStack {
                            Picker("Välj språk ", selection: $selectedLang) {
                                ForEach(lang, id: \.self){ i in
                                    Text(i)
                                }
                                
                                
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
}

struct AccountListView: View {
    @Binding var accounts : [AccountsPasswordManager]
     /*@State var accounts = [
        AccountsPasswordManager(websiteName: "1177.se", websiteUrl: "https://1177.se", username: "user1177", password: "p@ssw0rd1234"),
        AccountsPasswordManager(websiteName: "Figma.com", websiteUrl: "https://www.figma.com", username: "figmaUser2025", password: "figmaPass@567"),
        AccountsPasswordManager(websiteName: "jlt.se", websiteUrl: "https://www.jlt.se", username: "jltUser007", password: "jltSecure!2025")
    ]*/
    var body: some View {
            List {
                ForEach(accounts){ account in
                    NavigationLink(
                        destination: EditAccountView(account: account)) {
                        Text(account.websiteName)
                    }
                    
                }.onDelete(perform: deleteAccount)
            }.navigationTitle("Registerade konton")
        
    }
    
    func deleteAccount(at offsets: IndexSet) {
        accounts.remove(atOffsets: offsets)
    }
}

struct EditAccountView: View {
    @State var account : AccountsPasswordManager
    
    var body: some View {
        VStack {
            Text("Uppdatera din information på " + account.websiteName)
                .font(.title)
                .padding()
            
            Text("Hemsida")
            TextField(account.websiteUrl, text: $account.websiteUrl)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(RoundedRectangle(cornerRadius: 10))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.horizontal)
                
            Text("Användarnamn ")
            TextField(account.username, text: $account.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(RoundedRectangle(cornerRadius: 10))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.horizontal)
                
           
            Text("Lösenord ")
            TextField(account.password, text: $account.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(RoundedRectangle(cornerRadius: 10))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding(.horizontal)
                
        
            
        }
    }
}
#Preview {
    TESTVIEW()
}
