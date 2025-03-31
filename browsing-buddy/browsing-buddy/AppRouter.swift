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
    
    func navigateToMain(){
        navigationPath.append(Routes.MainView)
    }
    func navigateToAppSettings(){
        navigationPath.append(Routes.AppSettings)
    }
    func navigateToUserSettings(){
        navigationPath.append(Routes.UserSettings)
    }
    
    func navigateBack(){
        if (!navigationPath.isEmpty){
            navigationPath.removeLast()
        }
    }
}


enum Routes: Hashable {
    case MainView
    case AppSettings
    case UserSettings
}

/*
struct ContainerView: View {
    @State private var router = AppRouter()
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            ContentView(path: <#T##Binding<NavigationPath>#>)
                .environmentObject(router)
                .navigationDestination(for: Routes.self, destination: { route in
                    switch route {
                    case .AppSettings:
                        
                    case .UserSettings:
                        
                    }
                    
                })
            
        }
    }
}
*/
