//
//  ApiResponse.swift
//  News App
//
//  Created by Asalah Sayed on 31/07/2023.
//

import Foundation
struct APIResponse: Codable {
    let articles: [Article]?
}
struct Article: Codable{
    let source: Source
    let title: String?
    let description: String?
    let publishedAt: String?
    let urlToImage: String?
    let url: String?
    let author: String?
    let content: String?
    
}
struct Source:Codable {
    let name: String?
}
