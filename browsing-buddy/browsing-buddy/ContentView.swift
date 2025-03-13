//
//  ContentView.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import SwiftUI
import Foundation
import AVFoundation

//För min älskade switch
enum PopupType: Identifiable {
    case input(prompt: String, onSubmit: (String) -> Void)
    case message(text: String, onDismiss: () -> Void)

    var id: String {
        switch self {
        case .input:
            return "input"
        case .message:
            return "message"
        }
    }
}


// denna struct kommer vara enorm...
struct ContentView: View {
    @EnvironmentObject var userSession: UserSession
    @State private var webViewController: WebViewController? = nil
    @State private var currentButtons: [ButtonData] = []
    
    @State private var activePopup: PopupType? = nil
    private let speechManager = SpeechManager()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                EngineView(webViewController: $webViewController)
                    .frame(height: geometry.size.height * 0.8)

                HStack(spacing: 0) {
                    FavoriteButtonView(
                        buttons: userSession.currentUser.favoriteButtons,
                        onButtonTap: handleButtonTap,
                        color: userSession.currentUser.favoriteColor.toColor(),
                        fontSize: userSession.currentUser.textSize                   )
                    .frame(width: geometry.size.width * 0.4)

                    ActionButtonView(
                        buttons: currentButtons,
                        onButtonTap: handleButtonTap,
                        color: userSession.currentUser.mainColor.toColor(),
                        fontSize: userSession.currentUser.textSize
                    )
                    .frame(width: geometry.size.width * 0.6)
                }
                .frame(height: geometry.size.height * 0.2)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray),
                    alignment: .top
                )
            }
            .onChange(of: webViewController) { // Fuck you UIkit!!! Psykofanskap!!
                if let controller = webViewController {
                    controller.onRequestUserInput = { prompt, completion in
                        activePopup = .input(prompt: prompt, onSubmit: completion)
                    }

                    controller.onRequestShowMessage = { text, completion in
                        activePopup = .message(text: text, onDismiss: completion)
                    }
                }
            }
            .onAppear(){
                speechManager.listAvailableVoices()
            }
                    .sheet(item: $activePopup) { popup in
                        // Lazer Denis i farten igen =)
                        switch popup {
                            
                        case .input(let prompt, let onSubmit):
                            VStack {
                                Text(prompt)
                                    .font(.headline)
                                TextField("Skriv här...", text: .constant(""))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                Button("Godkänn") {
                                    onSubmit("Användarinput")
                                    activePopup = nil
                                }
                            }
                            .padding()

                        case .message(let text, let onDismiss):
                            messagePopupView(text: text, onDismiss: {
                                onDismiss()
                                activePopup = nil
                            })
                        }
                    }
                }
            }
    
    private func messagePopupView(text: String, onDismiss: @escaping () -> Void) -> some View {
           VStack {
               Text("Information")
                   .font(.title)
                   .fontWeight(.bold)
               Text(text)
                   .font(.headline)
                   .padding()

               Spacer()

               CustomButton(
                   text: "Text till tal",
                   color: Color.green,
                   fontSize: 22,
                   action: {
                       print("Talar") // Debugga skiten!!!
                       speechManager.speak(text) // Speak the message
                   }
               )

               CustomButtonWithClosure(
                   text: "OK",
                   color: Color.blue,
                   fontSize: 22,
                   action: {
                       speechManager.stopSpeaking() // Stop if speaking
                       onDismiss()
                       activePopup = nil
                   },
                   onClose: { activePopup = nil }
               )
           }
           .padding()
       }
    
    // äger knappen
    private func handleButtonTap(key: String) {
        let newButtons = orchestrator(key: key, webViewController: webViewController)
        currentButtons = newButtons
    }
}


//------------------------------ Flyttas senare eller inte =)

class SpeechManager {
    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String) {
        let tal = AVSpeechUtterance(string: text)
        tal.voice = AVSpeechSynthesisVoice(language: "sv-SE") // kanske gör till in-parameter ifall man lägger in överättare senare
        tal.rate = 0.5

        //Debug
        print("Using voice: \(tal.voice?.identifier ?? "Unknown")")
        synthesizer.speak(tal)
    }

    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    // Ta bort sen, endast för att kolla o det fanns röster / språk
    func listAvailableVoices() {
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            print("Voice Identifier: \(voice.identifier), Language: \(voice.language), Name: \(voice.name)")
        }
    }
}
