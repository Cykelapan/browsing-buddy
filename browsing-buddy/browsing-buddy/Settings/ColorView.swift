//
//  ColorView.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-31.
//

import SwiftUI

struct ColorView: View {
    @Binding  var mainColor: Color
    @Binding  var favColor: Color
    
    var body: some View {
        VStack {
            ColorPicker("Färg på hemsidaknappar", selection: $favColor)
            ColorPicker("Färg på hjälpknappar", selection: $mainColor)
        }
    }
}

#Preview {
    //ColorView()
}
