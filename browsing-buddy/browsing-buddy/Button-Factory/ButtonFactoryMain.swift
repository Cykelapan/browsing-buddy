//
//  ButtonFactoryMain.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-09.
//

import SwiftUI

struct ActionButtonView: View {
    let buttons: [UIButtonData]
    let onButtonTap: (UIButtonData) async -> Void
    let color: Color
    let fontSize: Int

    var body: some View {
        VStack(spacing: 5) {
            ForEach(buttons, id: \.nextStateKey) { buttonData in
                CustomButton(text: buttonData.buttonText, color: color, fontSize: fontSize) {
                    Task{await onButtonTap(buttonData)}
                }
                .frame(maxHeight: .infinity)
            }
        }
        .padding()
        .frame(maxHeight: .infinity)
    }
}

struct FavoriteButtonView: View {
    let buttons: [UIButtonData]
    let onButtonTap: (UIButtonData) async -> Void
    let color: Color
    let fontSize: Int

    var body: some View {
        VStack(spacing: 5) {
            ForEach(buttons, id: \.nextStateKey) { buttonData in
                CustomButton(text: buttonData.buttonText, color: color, fontSize: fontSize) {
                    
                    Task{await onButtonTap(buttonData)}
                }
                .frame(maxHeight: .infinity)
            }
        }
        .padding()
        .frame(maxHeight: .infinity)
    }
}

struct CustomButton: View {
    let text: String
    let color: Color
    let fontSize: Int
    let action: () -> Void
    

    var body: some View {
        Button(action: action) {
            Text(text)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .font(.system(size: CGFloat(fontSize)))
                .minimumScaleFactor(0.4)
                .lineLimit(1)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

struct CustomButtonWithClosure: View {
    let text: String
    let color: Color
    let fontSize: Int
    let action: () -> Void
    let onClose: (() -> Void)?

    var body: some View {
        Button(action: {
            action()
            onClose?()
        }) {
            Text(text)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .font(.system(size: CGFloat(fontSize)))
                .minimumScaleFactor(0.2)
                .lineLimit(1)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

struct NavigationButton: View {
    let text: String
    let color: Color
    let fontSize: Int
    let route: AppRoute
    @Binding var path: NavigationPath
    
    var body: some View {
        Button(action: {
            path.append(route)
        }) {
            Text(text)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(8)
                .font(.system(size: CGFloat(fontSize)))
        }
    }
}

struct NavigationButtonSetup: View {
    let text: String
    let color: Color
    let fontSize: Int
    let route: AppRouteSetup
    @Binding var path: NavigationPath
    @Binding var model: SetupModel
    
    var body: some View {
        Button(action: {
            path.append(route)
        }) {
            Text(text)
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .foregroundColor(.white)
                .cornerRadius(8)
                .font(.system(size: CGFloat(fontSize)))
        }
    }
}
