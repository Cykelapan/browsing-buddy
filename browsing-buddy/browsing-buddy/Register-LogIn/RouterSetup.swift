//
//  RouterSetup.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-15.
//

import Foundation
import SwiftUI

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
