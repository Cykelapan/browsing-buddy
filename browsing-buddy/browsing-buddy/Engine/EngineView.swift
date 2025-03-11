//
//  EngineView.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-10.
//

import SwiftUI
import UIKit

struct EngineView: UIViewControllerRepresentable {
    @Binding var webViewController: WebViewController?

    func makeUIViewController(context: Context) -> WebViewController {
        let controller = WebViewController()
        DispatchQueue.main.async {
            self.webViewController = controller
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
        self.webViewController = uiViewController
    }
}
