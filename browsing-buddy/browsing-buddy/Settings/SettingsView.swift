//
//  SettingsView.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-29.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var model =  SettingsModel()
    
    var body: some View {
        VStack{
            Form{
                Section("Hemsidor"){
                    FavoriteWebsitesView(selectedFavorites: $userSession.currentUser.favoriteButtons, avalibleWebsites: $model.avalibleWebsites).padding()
                }
                
                Section("Tecken strolek \(Int(model.fontSize))"){
                    Slider(value: $model.fontSize, in: 15...40, step: 1) {
                        Text("Point Size \(Int(model.fontSize))")
                    }
                    Text("Example på hur texten blir").font(.system(size: model.fontSize))
                }
                Section("Välj färg"){
                    ColorView(mainColor: $model.mainColor, favColor: $model.favoriteColor)
                }
            }
        }
        .onAppear(perform: {
            Task{
                await model.getInitalStates(selectedFavorites: userSession.currentUser.favoriteButtons)
                model.setColorFromUserSession(userSession: userSession)
            }
        })
        .onDisappear(perform: {
            
            model.updateColorUserSession(userSession: userSession)
        })
    }
}

#Preview {
    SettingsView()
}
