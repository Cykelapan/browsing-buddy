//
//  TESTVIEW.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-12.
//

import SwiftUI



//För settings av användare
// Textstorlek, Färg?, Favoriter

struct TESTVIEW: View {
    @State private var fontSize: CGFloat = 15
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        VStack{
            LabeledContent("iOS Version", value: "2.2.1")
            Section("Notes Font Size \(Int(fontSize))") {
                Slider(value: $fontSize, in: 10...40, step: 1) {
                    Text("Point Size \(Int(fontSize))")
                }
            }
            
        }.frame(width: 234, alignment: .center)
        
    }
}


#Preview {
    TESTVIEW()
}
