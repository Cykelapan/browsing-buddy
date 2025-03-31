//
//  Main-Page.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-12.
//

import SwiftUI

struct ParentView: View {
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ContentView(path: $path)
                .navigationDestination(for: AppRoute.self) { route in
                route.view(path: $path)
            }
        }
    }
}

#Preview {
    ParentView()
}






