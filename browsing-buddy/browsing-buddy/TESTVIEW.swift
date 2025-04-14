//
//  TESTVIEW.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-12.
//

import SwiftUI
import Observation


//För settings av användare
// Textstorlek, Färg?, Favoriter
//https://www.swiftanytime.com/blog/form-in-swiftui
struct TESTVIEW: View {
    @State private var fontSize: CGFloat = 15
    @State private var textToSpeech : Bool = false
    @State private var translation : Bool = false
    var lang = ["Svenska", "Finska", "Norska", "Danska"]
    @State private var selectedLang : String = "Svenska"
    @State private var singleSelectionAccounts: UUID? = nil
    
    @State var accounts = [
        AccountPasswordManager(websiteName: "1177", websiteUrl: "https://1177.se", username: "user1177", password: "p@ssw0rd1234"),
        AccountPasswordManager(websiteName: "Figma.com", websiteUrl: "https://www.figma.com", username: "figmaUser2025", password: "figmaPass@567"),
        AccountPasswordManager(websiteName: "jlt.se", websiteUrl: "https://www.jlt.se", username: "jltUser007", password: "jltSecure!2025")
    ]
    @State private var selectedFavorites: [UIButtonData] = []
    @State private var avalibleWebsites: [UIButtonData] =  []
    private var api = AzureFunctionsApi()
    
    var body: some View {
        NavigationStack {
            VStack{
                Form {
                    Section("Hemsidor") {
                        FavoriteWebsitesView(selectedFavorites: $selectedFavorites, avalibleWebsites: $avalibleWebsites).padding()
                        
                    }
                    
                    
                    
                    Section("Tecken strolek \(Int(fontSize))") {
                        Slider(value: $fontSize, in: 15...40, step: 1) {
                            Text("Point Size \(Int(fontSize))")
                        }
                        Text("Example på hur texten blir").font(.system(size: fontSize))
                    }
                    Section("Annat"){
                        
                        HStack {
                            Text("Hey").frame(alignment: .leading)
                            TextField("Text att läsa", text: $selectedLang).multilineTextAlignment(.trailing)
                        }
                        
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
        }.onAppear(perform: {
            Task{
                let request = GetAllInitialWebstateRequest()
                let result = await api.send(request)
                switch result {
                case.success(let data):
                    avalibleWebsites = data
                case .failure(let err):
                    print(err)
                }
                
            }
        })
    }
}


#Preview {
    TESTVIEW()
    //FavoriteWebsitesView()
}


/*
 Section("Personligt") {
     TextField("First Name", text: $firstName)
     TextField("Last Name", text: $lastName)
     
     
     DatePicker(
         "Födelsedatum",
         selection: $date,
         displayedComponents: [.date]
     )
 }
 
 */
