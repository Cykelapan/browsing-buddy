//
//  UserSettingsView.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-04-12.
//

@Observable
class AccountPasswordManager: Identifiable {
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


import SwiftUI

struct UserSettingsView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var userSession: UserSession
   
   
    var body: some View {
        VStack {
            Form {
                Section("Kopplade konton"){
                    AccountListView(accounts: $userSession.accounts)
                }
                
            }
        }.padding()
        
        .navigationTitle("Användarinställningar")
    }
}

struct AccountListView: View {
    @Binding var accounts : [AccountPasswordManager]
    @State private var selectedAccount : AccountPasswordManager?
    @State var showAddAccountView : Bool = false
    var body: some View {
        List(accounts) { account in
            HStack {
             
                Text(account.websiteName)
                Spacer()
                
                
            }.contentShape(Rectangle())
                .onTapGesture {
                    selectedAccount = account
                }
        }
        .sheet(item: $selectedAccount) { account in
            if let index = accounts.firstIndex(where: { $0.id == account.id }) {
                inputPopupView(account: $accounts[index]) // Pass binding here
            }
        }
        Button("Lägg till konto"){
            print("Lägg till konto")
            print(showAddAccountView)
            showAddAccountView.toggle()
            print(showAddAccountView)
        }.sheet(isPresented: $showAddAccountView) {
            AddAccountPasswordView(showPopup: $showAddAccountView)
        }
       
            
        
    }
 
    private func inputPopupView(account: Binding<AccountPasswordManager>) -> some View {
        VStack {
            
            Text(account.websiteName.wrappedValue).font(.title).fontWeight(.bold)
            
            Form {
                Section(header: Text("Användar information")) {
                    HStack {
                        Text("Användarnamn:")
                        TextField("Användarnamn", text: account.username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical)
                        
                    }
                    HStack{
                        Text("Lösenord: ")
                        TextField("Lösenord", text: account.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical)
                    }
                    
                    
                }
            }
            
            HStack {
                CustomButton(text: "Uppdatera", color: Color.green, fontSize: 22, action: {selectedAccount = nil})
                
                CustomButton(text: "Radera", color: Color.red, fontSize: 22, action: {selectedAccount = nil})
                
                CustomButton(text: "Tillbaka", color: Color.blue, fontSize: 22, action: { selectedAccount = nil })
                /*
                Button("Tabort") {
                    if let index = accounts.firstIndex(where: { $0.id == account.id }) {
                        accounts.remove(at: index)
                        showPopUp.toggle()
                    }
                }*/
            }
        }
        .padding()
    }
                
        
}
struct AddAccountPasswordView: View {
    @Binding var showPopup : Bool
    @EnvironmentObject var userSession: UserSession
    @State var selectedUsername : String = ""
    @State var selectedPassword : String = ""
    @State var confirmedSelectedPassword : String = ""
    @State var selectedWebsite : String = ""
    let avalibleWebsite : [String] = ["Google", "Facebook", "Twitter", "Instagram"]
    
    var passwordMatch: Bool {
        !selectedPassword.isEmpty && selectedPassword == confirmedSelectedPassword
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("Lägg till konto").font(.title).fontWeight(.bold)
              
                Form {
                    Section("Hemsida"){
                        Picker("Till hemsida", selection: $selectedWebsite) {
                            ForEach(avalibleWebsite, id: \.self){ i in
                                Text(i)
                            }
                        }
                    }
                    Section(header: Text("Användar information")) {
                        HStack {
                            Text("Användarnamn:")
                            TextField("Användarnamn", text: $selectedUsername)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical)
                            
                        }
                        HStack{
                            Text("Lösenord: ")
                            SecureField("Lösenord", text: $selectedPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical)
                        }
                        HStack{
                            Text("Säkerställ lösenord: ")
                            SecureField("Lösenord", text: $confirmedSelectedPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical)
                        }
                        
                        
                    }
                }
                
                HStack {
                    if passwordMatch {
                        CustomButton(text: "Lägg till", color: Color.green, fontSize: 22, action: {
                            userSession.accounts.append(AccountPasswordManager(websiteName: selectedWebsite, websiteUrl: selectedWebsite, username: selectedUsername, password: selectedPassword))
                            userSession.currentUser.email = selectedUsername
                            userSession.currentUser.password = selectedPassword
                            
                            showPopup.toggle()
                        })
                        
                    }
                    
                    
                    
                    CustomButton(text: "Tillbaka", color: Color.blue, fontSize: 22, action: {showPopup.toggle()})
                    
                }
            }
            .padding()
        }
                
        
    }
}
struct EditAccountView: View {
    @State var account : AccountPasswordManager
    @Binding var showPopup : Bool
    @Binding var accounts :  [AccountPasswordManager]
    
    var body: some View {
        VStack {
            VStack {
                Text(account.websiteName).font(.title).fontWeight(.bold)
              
                Form {
                    Section(header: Text("Användar information")) {
                        HStack {
                            Text("Användarnamn:")
                            TextField("Användarnamn", text: $account.username)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical)
                            
                        }
                        HStack{
                            Text("Lösenord: ")
                            TextField("Lösenord", text: $account.password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical)
                        }
                        
                        
                    }
                }
                
                HStack {
                    CustomButton(text: "Uppdatera", color: Color.green, fontSize: 22, action: {showPopup.toggle()})
                    
                    CustomButton(text: "Radera", color: Color.red, fontSize: 22, action: {showPopup.toggle()})
                    
                    CustomButton(text: "Tillbaka", color: Color.blue, fontSize: 22, action: {showPopup.toggle()})
                    
                    /*
                    Button("Tabort") {
                        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
                            accounts.remove(at: index)
                            showPopup.toggle()
                        }
                    }*/
                }
            }
            .padding()
        }
                
        
    }
}
#Preview {
    UserSettingsView()
}
