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
            ForEach(Array(buttons.enumerated()), id: \.element.key) { index, buttonData in
                createDynamicButton(text: buttonData.text, index: index)
            }
        }
        .padding()
    }
    
    struct Usersettings {
        static let textSize = 36;
        static let myColor: Color = Color.blue
    }

    func createDynamicButton(text: String, index: Int) -> some View {
        
        Button(action: buttonAction) { // replace later for preengine
            Text(text)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Usersettings.myColor)
                .font(.system(size: CGFloat(Usersettings.textSize)))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
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

