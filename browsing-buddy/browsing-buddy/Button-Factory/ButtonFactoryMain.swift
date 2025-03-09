//
//  ButtonFactoryMain.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-09.
//

import SwiftUI

struct ButtonData {
    let text: String
    let key: String
}

struct DynamicButtonView: View {
    
    @State private var buttons: [ButtonData] = [
        ButtonData(text: "Button 1", key: "btn1"),
        ButtonData(text: "Button 2", key: "btn2")
    ]

    var body: some View {
        VStack(spacing: 10) {
            ForEach(buttons, id: \.key) { buttonData in
                createDynamicButton(text: buttonData.text)
            }
        }
        .padding()
    }

    func createDynamicButton(text: String) -> some View {
        Button(action: buttonAction) {
            Text(text)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }

    func buttonAction() {
        buttons = [
            ButtonData(text: "Button 3", key: "btn1"),
            ButtonData(text: "Button 4", key: "btn2")
        ]
    }
}

struct ButtonView: View {
    var body: some View {
        DynamicButtonView()
    }
}
