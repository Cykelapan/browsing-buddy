//
//  TestMenu.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-29.
//

import SwiftUI

struct TestMenu: View {
    @State var presentSideMenu : Bool = false
    var body: some View {
        VStack {
            Text("HomeView")
            Button{
                presentSideMenu.toggle()
                
            } label: {
                Text("Menu")
            }
        }
    }
}

#Preview {
    TestMenu()
}
