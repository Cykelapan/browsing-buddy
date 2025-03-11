//
//  ContentView.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import SwiftUI

struct ContentView: View {
    @State private var webViewController: WebViewController? = nil
    @State private var currentButtons: [ButtonData] = [
        ButtonData(text: "Action 1", key: "1"),
        ButtonData(text: "Action 2", key: "2")
    ]

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EngineView(webViewController: $webViewController)
                    .frame(height: geometry.size.height * 0.8)

                DynamicButtonView(buttons: currentButtons, onButtonTap: handleButtonTap)
                    .frame(height: geometry.size.height * 0.2)
            }
        }
    }
    private func handleButtonTap(key: String) {
        let newButtons = orchestrator(key: key, webViewController: webViewController)
        currentButtons = newButtons
    }
}
