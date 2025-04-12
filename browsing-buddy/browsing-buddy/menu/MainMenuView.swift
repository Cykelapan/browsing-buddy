//
//  MainMenuView.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-04-12.
//

import SwiftUI
enum MainMenuItem: CaseIterable {
    case webview
    case iconView
    case userSettings
    case appSettings

    
    var itemName: String {
        switch self {
        case .webview:
            return "Hemsidor"
        case .iconView:
            return "Ikoner"
        case .userSettings:
            return "Användar Inställningar"
        case .appSettings:
            return "App Inställningar"
        }
    }
    func action (router:  AppRouter) -> Void{
        switch self{
        case .webview:
            router.navigateToWebview()
        case .iconView:
            router.navigateToIconsView()
        case .userSettings:
            router.navigateToUserSettings()
        case .appSettings:
            router.navigateToAppSettings()
        }
        
    }
}
struct MainMenuView: View {
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        VStack() {
            ForEach(MainMenuItem.allCases, id: \.self ){ item in
                CustomButton(text: item.itemName, color: Color.blue, fontSize: 22, action: {item.action(router: router)}).padding()
            }
        }.padding()
    }
}



struct AppSettingsView: View {
    @EnvironmentObject var router: AppRouter
    var body: some View {
        Text("Hello, AppSettingsView!")
        Button("Back") {
            router.navigateBack()
            
        }
    }
}

struct UserSettingsView: View {
    @EnvironmentObject var router: AppRouter
    var body: some View {
        Text("Hello, UserSettingsView!")
        Button("Back") {
            router.navigateBack()
            
        }
    }
}

#Preview {
    MainMenuView()
}
