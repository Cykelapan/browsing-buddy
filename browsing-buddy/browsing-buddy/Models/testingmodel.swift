//
//  testingmodel.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-09.
//

import Foundation
import CryptoKit

struct CosmosItem: Codable, Identifiable {
    let id: String
    let categoryId: String
    let categoryName: String
    let sku: String
    let name: String
    let description: String
    let price: Double
    let tags: [Tag]
}

struct Tag: Codable, Identifiable {
    let id: String
    let name: String
}

