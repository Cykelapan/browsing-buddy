//
//  ButtonFactoryMain.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-09.
//

import SwiftUI

struct Usersettings {
    static let textSize = 36
    static let myColor: Color = Color.blue
}

struct DynamicButtonView: View {
    let buttons: [ButtonData]
    let onButtonTap: (String) -> Void // Parent Måste äga funktionen åsna!!!!

    var body: some View {
        VStack(spacing: 10) {
            ForEach(buttons, id: \.key) { buttonData in Button(action: {
                    onButtonTap(buttonData.key)
                }) {
                    Text(buttonData.text)
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
        }
        .padding()
    }
}

