//
//  AppRouter.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-31.
//

import Foundation
import SwiftUI

class AppRouter: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    func navigateToWebview(){
        navigationPath.append(Routes.WebView)
    }
    
    func navigateToWebviewSettings(){
        navigationPath.append(Routes.WebViewSettings)
    }
    
    func navigateToIconsView(){
        navigationPath.append(Routes.IconListView)
    }
    func navigateToUserSettings(){
        navigationPath.append(Routes.UserSettings)
    }
    func navigateToAppSettings(){
        navigationPath.append(Routes.AppSettings)
    }
    
    func navigateBack(){
        if (!navigationPath.isEmpty){
            navigationPath.removeLast()
        }
    }
}


enum Routes: Hashable {
    case WebView
    case WebViewSettings
    case AppSettings
    case UserSettings
    case IconListView
    //case LandingPageView
    //case LoginView
    //case RegisterView
}


struct MainView: View {
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            MainMenuView()
                .environmentObject(router)
                .navigationTitle("Meny")
                .navigationDestination(for: Routes.self, destination: { route in
                    switch route {
                    case .AppSettings:
                        AppSettingsView()
                        
                    case .UserSettings:
                        UserSettingsView()
                        
                    case .WebView:
                        ContentView()
                        
                    case .WebViewSettings:
                        WebSettingsView()
                        
                    case .IconListView:
                        IconListView()
                        
                    //case .LandingPageView:
                        
                    //case .LoginView:
                        
                    //case .RegisterView:
                        
                    }
                    
                })
            
        }
    }
}


#Preview {
    MainView()
}
