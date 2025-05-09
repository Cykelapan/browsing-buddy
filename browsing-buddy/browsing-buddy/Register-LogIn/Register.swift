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
/* TODO:
 Array of PasswordManager -> website, username, password
 - Text size
 - Languages - text to speech and text exctraction
 - modeColor - dark/light
 - contrastText -
 - username nessesary or not ?
 - connected accounts - google calander, iOS, android or something else?
 - object with input text?
 - dob
 - 
 */
struct UserProfile: Codable {
    var userId: String
    var email: String
    var password: String
    var textSize: Int
    var mainColor: ColorData // Use ColorData here
    var favoriteColor: ColorData // Use ColorData here
    var favoriteButtons: [UIButtonData]

    // Example initializer
    init(
        userId: String,
        email: String,
        password: String,
        textSize: Int = 36,
        mainColor: Color = Color.blue,
        favoriteColor: Color = Color.red,
        favoriteButtons: [UIButtonData] =
        [
            //TODO: hämta intial state knappar
            UIButtonData(buttonText: "Kommunen", nextStateKey: "67d4dba68c54d4af6dcadbba"),
            UIButtonData(buttonText: "Figma", nextStateKey: "67d806f2b58290e926e20d30"),
            UIButtonData(buttonText: "SJ", nextStateKey: "67d81a7db58290e926e20d3c"),
            UIButtonData(buttonText: "Frågor", nextStateKey: "67d83702b58290e926e20d45")
            
        ]
    ) {
        self.userId = userId
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
    @Published var currentUser: UserProfile
    init(currentUser: UserProfile) {
        self.currentUser = currentUser
    }
}



