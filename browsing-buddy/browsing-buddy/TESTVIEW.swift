//
//  TESTVIEW.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-12.
//

import SwiftUI



//För settings av användare
// Textstorlek, Färg?, Favoriter
//https://www.swiftanytime.com/blog/form-in-swiftui
struct TESTVIEW: View {
    @State private var fontSize: CGFloat = 15
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var date = Date()
    @State private var darkmode : Bool = false
    var body: some View {
       
        VStack{
            Form{
                Section("Personal Information") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                
                        
                    DatePicker(
                        "Birthdate",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                }
                Section("Font Size \(Int(fontSize))") {
                    Slider(value: $fontSize, in: 10...40, step: 1) {
                        Text("Point Size \(Int(fontSize))")
                    }
                }
                Section("OTHER"){
                    Toggle("Darkmode", isOn: $darkmode)
                }
            }
        }
        
    }
}


#Preview {
    TESTVIEW()
}
