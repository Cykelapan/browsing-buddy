//
//  ContentView.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import SwiftUI

//användarinställningar
struct UserSettings {
    static let textSize = 36
    static let myColor: Color = Color.blue
    static let favoriteColor: Color = Color.red
    static let favoriteButtons: [ButtonData] = [
        ButtonData(text: "JLT", key: "3"),
        ButtonData(text: "Google", key: "4")
    ]
}

struct ContentView: View {
    @State private var webViewController: WebViewController? = nil
    @State private var currentButtons: [ButtonData] = []

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EngineView(webViewController: $webViewController)
                    .frame(height: geometry.size.height * 0.8)

                HStack(spacing: 0) {
                    FavoriteButtonView(
                        buttons: UserSettings.favoriteButtons,
                        onButtonTap: handleButtonTap,
                        color: UserSettings.favoriteColor,
                        fontSize: UserSettings.textSize
                    )
                    .frame(width: geometry.size.width * 0.4)

                    ActionButtonView(
                        buttons: currentButtons,
                        onButtonTap: handleButtonTap,
                        color: UserSettings.myColor,
                        fontSize: UserSettings.textSize
                    )
                    .frame(width: geometry.size.width * 0.6)
                }
                .frame(height: geometry.size.height * 0.2)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray),
                    alignment: .top
                )
            }
        }
    }
    
    private func handleButtonTap(key: String) {
        let newButtons = orchestrator(key: key, webViewController: webViewController)
        currentButtons = newButtons
    }
}
