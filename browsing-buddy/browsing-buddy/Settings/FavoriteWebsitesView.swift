//
//  FavoriteWebsitesView.swift
//  browsing-buddy
//
//  Created by Adam Granlund on 2025-03-29.
//

import SwiftUI

struct FavoriteWebsitesView: View {
    @Binding var selectedFavorites: [UIButtonData]
    @Binding var avalibleWebsites: [UIButtonData]
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Valda hemsidor").bold()
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(selectedFavorites, id: \.self) { favorite in
                            HStack {
                                Text(favorite.buttonText)
                                Spacer()
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.green.opacity(0.1)))
                            .onTapGesture {
                                removeFromFavorites(favorite)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading) {
                Text("Tillgängliga hemsidor").bold()
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(avalibleWebsites, id: \.self) { avalible in
                            HStack {
                                Text(avalible.buttonText)
                                Spacer()
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color.blue.opacity(0.1)))
                            .onTapGesture {
                                moveToFavorites(avalible)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 350)
    }
    
    private func moveToFavorites(_ data : UIButtonData) {
        guard let index = avalibleWebsites.firstIndex(of: data) else { return }
        avalibleWebsites.remove(at: index)
        selectedFavorites.append(data)
    }

    private func removeFromFavorites(_ data: UIButtonData) {
        guard let index = selectedFavorites.firstIndex(of: data) else { return }
        selectedFavorites.remove(at: index)
        avalibleWebsites.append(data)
    }
}
