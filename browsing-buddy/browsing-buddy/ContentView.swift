//
//  ContentView.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import SwiftUI

struct ContentView: View {
    @State private var webViewController: WebViewController? = nil
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EngineView(webViewController: $webViewController)
                    .frame(height: geometry.size.height * 0.8)

                //UIButtons(webViewController: webViewController)
                    //.frame(height: geometry.size.height * 0.2)
            }
        }

    }
}
