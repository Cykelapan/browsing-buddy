//
//  TESTVIEW.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-12.
//

import SwiftUI
import Observation


//För settings av användare
// Textstorlek, Färg?, Favoriter
//https://www.swiftanytime.com/blog/form-in-swiftui
struct TESTVIEW: View {
    @State private var fontSize: CGFloat = 15
    @State private var textToSpeech : Bool = false
    @State private var translation : Bool = false
    let date = Date()
    
    
    var body: some View {
        NavigationStack {
            VStack{
                Form {
                   
                        
                    }
                    
                    
                    
                    Section("Tecken strolek \(Int(fontSize))") {
                        Slider(value: $fontSize, in: 15...40, step: 1) {
                            Text("Point Size \(Int(fontSize))")
                        }
                        Text("Example på hur texten blir").font(.system(size: fontSize))
                    }
                    Section("Annat"){
                        
                        HStack {
                            Text("Hey").frame(alignment: .leading)
                            Button("hey"){
                                print(date.description)
                            }
                            
                        }
                        
                        HStack {
                            
                        }
                    }
                    
                    
                }
            }
        }
}


#Preview {
    TESTVIEW()
    //FavoriteWebsitesView()
}


/*
 Section("Personligt") {
     TextField("First Name", text: $firstName)
     TextField("Last Name", text: $lastName)
     
     
     DatePicker(
         "Födelsedatum",
         selection: $date,
         displayedComponents: [.date]
     )
 }
 
 */
