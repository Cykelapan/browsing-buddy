//
//  Register.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-12.
//
import SwiftUI
import Foundation

struct ButtonData: Codable {
    let text: String
    let key: String
}

struct UserProfile: Codable {
    var username: String
    var email: String
    var password: String
    var textSize: Int
    var mainColor: ColorData // Use ColorData here
    var favoriteColor: ColorData // Use ColorData here
    var favoriteButtons: [ButtonData]

    // Example initializer
    init(
        username: String = "",
        email: String = "",
        password: String = "",
        textSize: Int = 36,
        mainColor: Color = Color.blue,
        favoriteColor: Color = Color.red,
        favoriteButtons: [ButtonData] =
        [
            ButtonData(text: "Polisen", key: "3"),
            ButtonData(text: "Seniortorget", key: "4")
        ]
    ) {
        self.username = username
        self.email = email
        self.password = password
        self.textSize = textSize
        self.mainColor = ColorData(color: mainColor) // Wrap Color
        self.favoriteColor = ColorData(color: favoriteColor) // Wrap Color
        self.favoriteButtons = favoriteButtons
    }
}

struct ColorData: Codable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double

    init(color: Color) {
        let uiColor = UIColor(color)
        var red: CGFloat = 0, green: CGFloat = 0,
            blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.red = Double(red)
        self.green = Double(green)
        self.blue = Double(blue)
        self.opacity = Double(alpha)
    }

    func toColor() -> Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

class UserSession: ObservableObject {
    @Published var currentUser: UserProfile? = UserProfile()
}



