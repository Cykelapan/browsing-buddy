//
//  SwiftUIView.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-04-12.
//

import SwiftUI

    enum CommonWebIcons: CaseIterable {
        case home, search, user, settings, menu, close, add, delete, edit, save
        case upload, download, notification, message, logout, login, cart, favorite, share, info

        var displayName: String {
            switch self {
            case .home: return "Hem"
            case .search: return "Sök"
            case .user: return "Användare"
            case .settings: return "Inställningar"
            case .menu: return "Meny"
            case .close: return "Stäng"
            case .add: return "Lägg till"
            case .delete: return "Ta bort"
            case .edit: return "Redigera"
            case .save: return "Spara"
            case .upload: return "Ladda upp"
            case .download: return "Ladda ner"
            case .notification: return "Avisering"
            case .message: return "Meddelande"
            case .logout: return "Logga ut"
            case .login: return "Logga in"
            case .cart: return "Varukorg"
            case .favorite: return "Favorit"
            case .share: return "Dela"
            case .info: return "Information"
            }
        }

        var description: String {
            switch self {
            case .home: return "tar dig till huvudsidan"
            case .search: return "används för att hitta innehåll"
            case .user: return "profil eller kontoinställningar"
            case .settings: return "justera preferenser eller konfiguration"
            case .menu: return "öppnar en navigationsmeny"
            case .close: return "stänger ett fönster eller popup"
            case .add: return "skapa eller lägg till nytt innehåll"
            case .delete: return "raderar ett objekt"
            case .edit: return "ändra befintlig information"
            case .save: return "bekräftar ändringar"
            case .upload: return "överför filer till systemet"
            case .download: return "hämta filer från systemet"
            case .notification: return "meddelanden eller uppdateringar"
            case .message: return "kommunikation eller chatt"
            case .logout: return "avsluta sessionen"
            case .login: return "autentisera användare"
            case .cart: return "visa valda köp"
            case .favorite: return "markera något som gillat"
            case .share: return "skicka innehåll till andra"
            case .info: return "visa mer detaljer eller hjälp"
            }
        }

        var symbolName: String {
            switch self {
            case .home: return "house.fill"
            case .search: return "magnifyingglass"
            case .user: return "person.crop.circle"
            case .settings: return "gearshape.fill"
            case .menu: return "line.3.horizontal"
            case .close: return "xmark.circle.fill"
            case .add: return "plus.circle.fill"
            case .delete: return "trash.fill"
            case .edit: return "pencil"
            case .save: return "square.and.arrow.down"
            case .upload: return "arrow.up.circle"
            case .download: return "arrow.down.circle"
            case .notification: return "bell.fill"
            case .message: return "message.fill"
            case .logout: return "rectangle.portrait.and.arrow.right"
            case .login: return "rectangle.portrait.and.arrow.forward"
            case .cart: return "cart.fill"
            case .favorite: return "heart.fill"
            case .share: return "square.and.arrow.up"
            case .info: return "info.circle.fill"
            }
        }

        var font: Font {
            switch self {
            case .user, .settings, .info:
                return .system(.body, design: .serif)
            case .message, .notification, .edit:
                return .system(.body, design: .monospaced)
            case .search, .login, .logout:
                return .system(.headline)
            case .favorite, .share, .menu:
                return .system(.subheadline)
            default:
                return .system(.body)
            }
        }
    }


struct IconListView: View {
    var body: some View {
        List(CommonWebIcons.allCases, id: \.self) { ikon in
            HStack(spacing: 12) {
                Image(systemName: ikon.symbolName)
                    .font(.system(size: 36))
                    .frame(width: 30)
                    .foregroundColor(.accentColor)

                VStack(alignment: .leading) {
                    Text(ikon.displayName)
                        .font(.headline)
                    Text(ikon.description)
                        .font(ikon.font)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 6)
        }
    }
}

struct IconListView_Previews: PreviewProvider {
    static var previews: some View {
        IconListView()
    }
}
