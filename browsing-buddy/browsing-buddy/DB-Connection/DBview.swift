//
//  DBview.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-09.
//

import SwiftUI
import CryptoKit

struct CosmosDBView: View {
    @State private var item: CosmosItem? = nil
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading from Cosmos DB...")
                    .padding()
            } else if let item = item {
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Name: \(item.name)").font(.title).bold()
                        Text("Category: \(item.categoryName)").font(.headline).foregroundColor(.blue)
                        Text("SKU: \(item.sku)").font(.subheadline).foregroundColor(.gray)
                        Text("Description: \(item.description)").font(.body)
                        Text("Price: $\(item.price, specifier: "%.2f")").font(.headline).foregroundColor(.green)
                        
                        Text("Tags:").font(.headline)
                        ForEach(item.tags) { tag in
                            Text("• \(tag.name)").font(.subheadline).foregroundColor(.orange)
                        }
                    }
                    .padding()
                }
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)").foregroundColor(.red).padding()
            }
        }
        .onAppear {
            fetchData()
        }
    }

    func fetchData() {
        let primaryKey = "" // Regenerated key from Azure
        let endpoint = ""
        let resourceLink = ""
        let date = DateFormatter.rfc1123.string(from: Date())

        guard let url = URL(string: endpoint) else {
            print("❌ Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Query requires POST

        let query = [
            "query": "SELECT * FROM c WHERE c.id = '027D0B9A-F9D9-4C96-8213-C8546C4AAE71'"
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: query, options: []) else {
            print("❌ Failed to encode query JSON")
            return
        }

        let authHeader = createAuthorizationHeader(
            verb: "POST",
            resourceType: "docs",
            resourceLink: resourceLink, // Query operates on collection level
            date: date,
            primaryKey: primaryKey
        )

        request.addValue("2018-12-31", forHTTPHeaderField: "x-ms-version")
        request.addValue(authHeader, forHTTPHeaderField: "Authorization")
        request.addValue(date, forHTTPHeaderField: "x-ms-date")
        request.addValue("application/query+json", forHTTPHeaderField: "Content-Type")
        request.addValue("true", forHTTPHeaderField: "x-ms-documentdb-isquery")

        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Request Error: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("TTP Status Code: \(httpResponse.statusCode)")
                }

                if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON Response:\n\(jsonString)")
                } else {
                    print("No data received.")
                }
            }
        }.resume()
    }

    func createAuthorizationHeader(verb: String, resourceType: String, resourceLink: String, date:
        String, primaryKey: String) -> String {
        
        
        let stringToSign = "\(verb.lowercased())\n\(resourceType.lowercased())\n\(resourceLink)\n\(date.lowercased())\n\n"
        print("String to Sign:\n\(stringToSign)") // Debugging output

        guard let keyData = Data(base64Encoded: primaryKey) else {
            print("Failed to decode primary key.")
            return ""
        }

        let stringData = stringToSign.data(using: .utf8)!
        let hmac = HMAC<SHA256>.authenticationCode(for: stringData, using: SymmetricKey(data: keyData))
        let signature = Data(hmac).base64EncodedString()

        let authHeader = "type=master&ver=1.0&sig=\(signature)"
        print("Authorization Header:\n\(authHeader)") // Debugging output
        return authHeader
    }
}

extension DateFormatter {
    static let rfc1123: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        return formatter
    }()
}

struct CosmosDBView_Previews: PreviewProvider {
    static var previews: some View {
        CosmosDBView()
    }
}


