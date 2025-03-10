//
//  Atlas.swift
//  browsing-buddy
//
//  Created by Denis Ureke on 2025-03-10.
//

import MongoSwift
import NIOPosix

func readDocumentsFromMongoDB() {
    let elg = MultiThreadedEventLoopGroup(numberOfThreads: 4)

    do {
        // Connect to MongoDB Atlas
        let client = try MongoClient(
            "mongodb+srv://urekedenis:93n4zraL7Tx8c1yc@browsing-buddy.xugiw.mongodb.net/?retryWrites=true&w=majority&appName=browsing-buddy",
            using: elg
        )

        defer {
            // Cleanup
            try? client.syncClose()
            cleanupMongoSwift()
            try? elg.syncShutdownGracefully()
        }

        // Select database and collection
        let database = client.db("browsing-buddy")
        let collection = database.collection("users")

        // Fetch all documents
        let documents = try collection.find().wait()

        // Print each document
        for doc in documents {
            print(doc)
        }

    } catch {
        print("Failed to read from MongoDB: \(error)")
    }
}
