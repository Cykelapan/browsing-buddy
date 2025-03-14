//
//  ContentView.swift
//  browsing-buddy
//
//  Created by Frida Granlund on 2025-03-09.
//

import SwiftUI
import Foundation
import AVFoundation
import EventKit

//För min älskade switch
enum PopupType: Identifiable {
    case input(prompt: String, onSubmit: (String) -> Void)
    case message(title: String, text: String, onDismiss: () -> Void)

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
                EngineView(webViewController: $webViewController, userSession: userSession)
                    .frame(height: geometry.size.height * 0.8)

                HStack(spacing: 0) {
                    FavoriteButtonView(
                        buttons: userSession.currentUser?.favoriteButtons ?? [],
                        onButtonTap: handleButtonTap,
                        color: userSession.currentUser?.favoriteColor.toColor() ?? .red,
                        fontSize: userSession.currentUser?.textSize ?? 36                    )
                    .frame(width: geometry.size.width * 0.4)

                    ActionButtonView(
                        buttons: currentButtons,
                        onButtonTap: handleButtonTap,
                        color: userSession.currentUser?.mainColor.toColor() ?? .blue,
                        fontSize: userSession.currentUser?.textSize ?? 36
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
                    controller.onRequestShowMessage = { title, text, completion in
                        activePopup = .message(title: title, text: text, onDismiss: completion)
                    }
                }
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
                        case .message(let title, let text, let onDismiss):
                            messagePopupView(title: title, text: text, onDismiss: {
                                onDismiss()
                                activePopup = nil
                            })
                        }
                    }
                }
            }
    
    private func messagePopupView(title: String, text: String, onDismiss: @escaping () -> Void) -> some View {
           VStack {
               Text(title)
                   .font(.title)
                   .fontWeight(.bold)
               
               ScrollView{
                   Text(text)
                       .font(.headline)
                       .padding()
               }

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
               
               CustomButton(
                   text: "Lägg till i kalender",
                   color: Color.orange,
                   fontSize: 22,
                   action: {
                       print("Förbereder för kalenderinläggning...")

                       // Parse events first
                       let parser = EventManagerEventParser()
                       let parsedEvents = parser.parseStringToInsert(input: text)
                       print("🔍 Antal hittade event: \(parsedEvents.count)")

                       // Insert with calendar access request
                       let calendarManager = CalendarEventManager()
                       calendarManager.printAvailableCalendars() // 👈 Add this line to debug calendars
                       calendarManager.requestAccessAndInsertEvents(events: parsedEvents)
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

        synthesizer.speak(tal)
    }

    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

struct ParsedEvent {
    let title: String
    let startDate: Date
    let endDate: Date?
}

class EventManagerEventParser {
    
    let swedishMonthMap: [String: Int] = [
        "januari": 1, "februari": 2, "mars": 3, "april": 4, "maj": 5, "juni": 6,
        "juli": 7, "augusti": 8, "september": 9, "oktober": 10, "november": 11, "december": 12
    ]
    
    func parseStringToInsert(input: String) -> [ParsedEvent] {
        return parseEventsFromString(input)
    }
    
    private func parseEventsFromString(_ input: String) -> [ParsedEvent] {
        var parsedEvents: [ParsedEvent] = []
        
        let dateBlockPattern = "(?=^[A-Öa-ö]+ \\d{1,2} [a-ö]+:)"
        let regex = try! NSRegularExpression(pattern: dateBlockPattern, options: [.anchorsMatchLines])
        let nsrange = NSRange(input.startIndex..<input.endIndex, in: input)
        
        let matches = regex.matches(in: input, options: [], range: nsrange)
        
        var blocks: [String] = []
        var lastIndex = input.startIndex
        
        for match in matches {
            let range = Range(match.range, in: input)!
            if range.lowerBound != lastIndex {
                let block = String(input[lastIndex..<range.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
                if !block.isEmpty {
                    blocks.append(block)
                }
            }
            lastIndex = range.lowerBound
        }
        
        let finalBlock = String(input[lastIndex...]).trimmingCharacters(in: .whitespacesAndNewlines)
        if !finalBlock.isEmpty {
            blocks.append(finalBlock)
        }
        
        // Step 2: Process each block
        for block in blocks {
            let eventsInBlock = processDateBlock(block)
            parsedEvents.append(contentsOf: eventsInBlock)
        }
        
        return parsedEvents
    }
    
    private func processDateBlock(_ block: String) -> [ParsedEvent] {
        var events: [ParsedEvent] = []
        
        // Ta ut datum
        let datePattern = "^[A-Öa-ö]+ (\\d{1,2}) ([a-ö]+):"
        let dateRegex = try! NSRegularExpression(pattern: datePattern, options: [])
        guard let match = dateRegex.firstMatch(in: block, options: [], range: NSRange(block.startIndex..., in: block)),
              let dayRange = Range(match.range(at: 1), in: block),
              let monthRange = Range(match.range(at: 2), in: block) else {
            return events // No valid date found
        }
        
        let day = Int(block[dayRange])!
        let monthStr = String(block[monthRange]).lowercased()
        guard let month = swedishMonthMap[monthStr] else { return events }
        
        // Ta ut tider och event
        // Tack ChatGPT!
        let timePattern = "(?:kl\\.?|klockan)\\s*(\\d{1,2}\\.\\d{2})(?:\\s*-\\s*(\\d{1,2}\\.\\d{2}))?(.+?)(?=(?:kl\\.?|klockan|$))"
        let timeRegex = try! NSRegularExpression(pattern: timePattern, options: [.dotMatchesLineSeparators])
        let nsrange = NSRange(block.startIndex..<block.endIndex, in: block)
        
        let timeMatches = timeRegex.matches(in: block, options: [], range: nsrange)
        
        for match in timeMatches {
            let startTimeStr = String(block[Range(match.range(at: 1), in: block)!])
            let endTimeStr = match.range(at: 2).location != NSNotFound ? String(block[Range(match.range(at: 2), in: block)!]) : nil
            let description = String(block[Range(match.range(at: 3), in: block)!]).trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Skapa datum
            let calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.year = Calendar.current.component(.year, from: Date()) // Assume current year
            dateComponents.month = month
            dateComponents.day = day
            
            // skapa start tid
            let startParts = startTimeStr.split(separator: ".").compactMap { Int($0) }
            dateComponents.hour = startParts[0]
            dateComponents.minute = startParts[1]
            guard let startDate = calendar.date(from: dateComponents) else { continue }
            
            // skapa sluttid ifall det finns
            var endDate: Date? = nil
            if let endStr = endTimeStr {
                var endComponents = dateComponents
                let endParts = endStr.split(separator: ".").compactMap { Int($0) }
                endComponents.hour = endParts[0]
                endComponents.minute = endParts[1]
                endDate = calendar.date(from: endComponents)
            }
            
            // skapa event
            let event = ParsedEvent(title: description, startDate: startDate, endDate: endDate)
            events.append(event)
        }
        
        return events
    }
}


class CalendarEventManager {

    private let eventStore = EKEventStore()

    // Public function to request access and insert events
    func requestAccessAndInsertEvents(events: [ParsedEvent]) {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents { [weak self] granted, error in
                guard let self = self else { return }
                if granted {
                    DispatchQueue.main.async {
                        self.insertEvents(events: events)
                    }
                } else {
                    print("❌ Calendar access denied.")
                }
            }
        } else {
            eventStore.requestAccess(to: .event) { [weak self] granted, error in
                guard let self = self else { return }
                if granted {
                    DispatchQueue.main.async {
                        self.insertEvents(events: events)
                    }
                } else {
                    print("❌ Calendar access denied.")
                }
            }
        }
    }

    // Insert events safely
    private func insertEvents(events: [ParsedEvent]) {
        for event in events {
            self.checkAndInsert(event: event)
        }
    }

    // Check for duplicates and add if not existing
    private func checkAndInsert(event: ParsedEvent) {
        let startSearchDate = Calendar.current.date(byAdding: .hour, value: -1, to: event.startDate)!
        let endSearchDate = Calendar.current.date(byAdding: .hour, value: 1, to: event.startDate)!

        let predicate = eventStore.predicateForEvents(withStart: startSearchDate, end: endSearchDate, calendars: nil)
        let existingEvents = eventStore.events(matching: predicate)

        let alreadyExists = existingEvents.contains { existingEvent in
            existingEvent.title == event.title &&
            Calendar.current.isDate(existingEvent.startDate, equalTo: event.startDate, toGranularity: .minute)
        }

        if alreadyExists {
            print("⚠️ Event '\(event.title)' already exists. Skipping.")
            return
        }

        let calendarEvent = EKEvent(eventStore: eventStore)
        calendarEvent.title = event.title
        calendarEvent.startDate = event.startDate
        calendarEvent.endDate = event.endDate ?? event.startDate.addingTimeInterval(3600) // Default 1-hour event
        calendarEvent.calendar = eventStore.defaultCalendarForNewEvents

        do {
            try eventStore.save(calendarEvent, span: .thisEvent)
            print("✅ Event added: \(event.title) on \(event.startDate)")
        } catch {
            print("❌ Failed to save event: \(error.localizedDescription)")
        }
    }
    
    func printAvailableCalendars() {
        let calendars = eventStore.calendars(for: .event)
        print("📅 --- Available Calendars ---")
        for calendar in calendars {
            print("📅 Calendar Name: \(calendar.title) | ID: \(calendar.calendarIdentifier) | Is Default: \(calendar == eventStore.defaultCalendarForNewEvents)")
        }
        print("📅 --------------------------")
    }
}
