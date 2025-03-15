//
//  SubRegisterButton.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-13.
//

import SwiftUI

struct SubRegisterButton: View {
    var body: some View {
        Button {
            //aktivera registering
            
        } label: {
            Text("Registera dig")
                .frame(maxWidth: .infinity)
        }.buttonStyle(.borderedProminent)
    }
    
}

#Preview {
    SubRegisterButton()
}
