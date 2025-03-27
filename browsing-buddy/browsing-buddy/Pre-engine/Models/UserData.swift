//
//  UserData.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import Foundation


struct UserData: Codable {
    let _id : String
    let email : String
    let passwordApp : String
}

// Need to encrypt/hash before sending to the db
struct PasswordManagerData: Codable {
    let _id : String
    let website : String
    let username : String
    let password : String
    let userId : String
}

// Vad mer behöver vi 
struct UserPersonalInformation: Codable {
    let _id : String
    let firstName : String
    let lastName : String
    let dob : String
    let street : String
    let postcode : String
    let city : String
    
    let userId : String
}


// Vad mer är av behov nu?
struct UserSettings: Codable {
    let _id : String
    let textSize : Int
    let languageToUse : String
    //let textToSpeechActive : Bool
    //let translationActive : Bool
    let favoriteWebsites : [UIButtonData]
    let userId : String
}
