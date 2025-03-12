//
//  ContentView.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import SwiftUI
import Foundation

//För min älskade switch
enum PopupType: Identifiable {
    case input(prompt: String, onSubmit: (String) -> Void)
    case message(text: String, onDismiss: () -> Void)

    var id: String {
        switch self {
        case .input:
            return "input"
        case .message:
            return "message"
        }
    }
}

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

// denna struct kommer vara enorm...
struct ContentView: View {
    @State private var webViewController: WebViewController? = nil
    @State private var currentButtons: [ButtonData] = []
    
    @State private var activePopup: PopupType? = nil

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
            .onChange(of: webViewController) { // Fuck you UIkit!!! Psykofanskap!!
                if let controller = webViewController {
                    controller.onRequestUserInput = { prompt, completion in
                        activePopup = .input(prompt: prompt, onSubmit: completion)
                    }

                    controller.onRequestShowMessage = { text, completion in
                        activePopup = .message(text: text, onDismiss: completion)
                    }
                }
            }
                    .sheet(item: $activePopup) { popup in
                        // Lazer Denis i farten igen =)
                        switch popup {
                            
                        case .input(let prompt, let onSubmit):
                            VStack {
                                Text(prompt)
                                    .font(.headline)
                                TextField("Skriv här...", text: .constant(""))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                Button("Godkänn") {
                                    onSubmit("Användarinput")
                                    activePopup = nil
                                }
                            }
                            .padding()

                        case .message(let text, let onDismiss):
                            VStack {
                                Text(text)
                                    .font(.headline)
                                    .padding()
                                Button("OK") {
                                    onDismiss()
                                    activePopup = nil
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
    // äger knappen
    private func handleButtonTap(key: String) {
        let newButtons = orchestrator(key: key, webViewController: webViewController)
        currentButtons = newButtons
    }
}
