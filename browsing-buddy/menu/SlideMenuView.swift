//
//  SlideMenuView.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-29.
//

import SwiftUI

enum SideMenuRowType: Int, CaseIterable {
    case contentView = 0
    case settings
    
    var title: String {
        switch self {
        case .contentView:
            return "Webview"
        case .settings:
            return "SettingsView"
        }
    }
    
}


struct SlideMenuView: View {
    @State var isShowing: Bool = false
    var content: AnyView
    var edgeTransition: AnyTransition = .move(edge: .leading)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isShowing) {
                Color.black
                    .opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                content
                    .transition(edgeTransition)
                    .background(Color.clear)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeOut, value: isShowing)
    }
}

#Preview {
   // SlideMenuView()
}
