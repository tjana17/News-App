//
//  DataModel.swift
//  News-App
//
//  Created by DB-MBP-023 on 27/05/24.
//

import Foundation

// MARK: - DataModel
struct DataModel: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
