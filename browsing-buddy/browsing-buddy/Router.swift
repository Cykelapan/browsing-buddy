//
//  Router.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-12.
//

import SwiftUI

enum AppRoute: Hashable {
    
    case contentView

    
    @ViewBuilder
    func view(path: Binding<NavigationPath>) -> some View {
        switch self {
        case .contentView:
            ContentView()
     
            
        }
    }
}


enum AppRouteSetup: Hashable {
    case registrera
    case login
    
    @ViewBuilder
    func view(path: Binding<NavigationPath>, model: Binding<SetupModel>) -> some View {
        switch self {
        case .registrera:
            RegisterView(path: path, model: model)
        case .login:
            LoginView(path: path, model: model)
            
        }
    }
}
