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



func createUserProfileFromData(userData: UserData, userSettings: UserSettings) -> UserProfile {
    return UserProfile(userId: userData._id,
                       email: userData.email,
                       password: userData.passwordApp,
                       textSize: userSettings.textSize,
                       mainColor: ColorData(color: Color.blue),
                       favoriteColor: ColorData(color: Color.red),
                       favoriteButtons: userSettings.favoriteWebsites )
}

func createUserProfileFrom(userData: UserData,
                       textSize: Int = 36,
                       mainColor: Color = Color.blue,
                       favoriteColor: Color = Color.red,
                       favoriteButtons: [UIButtonData] =
                       [
                           //TODO: hämta intial state knappar
                           UIButtonData(buttonText: "Jönköping kommun", nextStateKey: "67d4dba68c54d4af6dcadbba"),
                           UIButtonData(buttonText: "1177", nextStateKey: "67e453ab63361512f537556f"),
                           UIButtonData(buttonText: "FASS", nextStateKey: "67e44ee363361512f537556b")
                           //UIButtonData(buttonText: "Google", nextStateKey: "67d85394b58290e926e20d4d"),
                           //UIButtonData(buttonText: "Figma", nextStateKey: "67d806f2b58290e926e20d30"),
                           //UIButtonData(buttonText: "SJ", nextStateKey: "67d81a7db58290e926e20d3c"),
                           //UIButtonData(buttonText: "Frågor", nextStateKey: "67d83702b58290e926e20d45")
                           
                       ]) -> UserProfile {
                           
                           return UserProfile(userId: userData._id,
                                              email: userData.email,
                                              password: userData.passwordApp,
                                              textSize: textSize,
                                              mainColor: ColorData(color: mainColor),
                                              favoriteColor: ColorData(color: favoriteColor),
                                              favoriteButtons: favoriteButtons)
}

func createUserProfile(userId: String,
                       email: String,
                       password: String,
                       textSize: Int = 36,
                       mainColor: Color = Color.blue,
                       favoriteColor: Color = Color.red,
                       favoriteButtons: [UIButtonData] =
                       [
                           //TODO: hämta intial state knappar
                           UIButtonData(buttonText: "Jönköping kommun", nextStateKey: "67d4dba68c54d4af6dcadbba"),
                           UIButtonData(buttonText: "1177", nextStateKey: "67e453ab63361512f537556f"),
                           UIButtonData(buttonText: "FASS", nextStateKey: "67e44ee363361512f537556b")
                           //UIButtonData(buttonText: "Google", nextStateKey: "67d85394b58290e926e20d4d"),
                           //UIButtonData(buttonText: "Figma", nextStateKey: "67d806f2b58290e926e20d30"),
                           //UIButtonData(buttonText: "SJ", nextStateKey: "67d81a7db58290e926e20d3c"),
                           //UIButtonData(buttonText: "Frågor", nextStateKey: "67d83702b58290e926e20d45")
                           
                       ]) -> UserProfile {
                           return UserProfile(userId: userId, email: email, password: password, textSize: textSize, mainColor: ColorData(color: mainColor), favoriteColor: ColorData(color: favoriteColor), favoriteButtons: favoriteButtons)
}


class UserSession: ObservableObject {
    @Published var currentUser: UserProfile
    @Published var userInput: String = ""
    @Published var valueToIbject: String = ""
    init(currentUser: UserProfile) {
        self.currentUser = currentUser
    }
}



