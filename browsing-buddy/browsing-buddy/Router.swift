//
//  Router.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-12.
//

import SwiftUI

enum AppRoute: Hashable {
    case registrera
    case contentView
    case login
    
    @ViewBuilder
    func view(path: Binding<NavigationPath>) -> some View {
        switch self {
        case .registrera:
            RegisterView(path: path)
        case .contentView:
            ContentView()
        case .login:
            LoginView(path: path)
            
        }
    }
}
