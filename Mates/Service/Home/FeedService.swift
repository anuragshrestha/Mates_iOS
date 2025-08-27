//
//  AroundYouService.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/18/25.
//

import Foundation

struct HomeFeedResponse: Decodable {
    
     let success: Bool
     let posts: [PostModel]
     let user_id: String
     let hasMore: Bool?
     let currentPage: Int?
     let totalPosts: Int?
}

enum AroundYouServiceError: Error {
    
    case unauthorized
    case nodata
    case invalidResponse(status:Int, error: String)
    case urlError
    case decodingError
}

final class FeedService {
    static let shared = FeedService()
    private init() {}
    
    func fetchFeed(kind: FeedKind, page: Int = 1, limit: Int = 6) async throws -> HomeFeedResponse {
        guard let accessToken = KeychainHelper.loadAccessToken() else {
            throw AroundYouServiceError.unauthorized
        }
        
        guard var urlComponents = URLComponents(string: "\(Config.baseURL)/feeds\(kind.path)") else {
            throw AroundYouServiceError.urlError
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        guard let url = urlComponents.url else { throw AroundYouServiceError.urlError }
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else {
            throw AroundYouServiceError.invalidResponse(status: -1, error: "No HTTP Response")
        }
        guard http.statusCode == 200 else {
            let err = (try? JSONDecoder().decode([String:String].self, from: data)["error"]) ?? "Unknown error"
            throw AroundYouServiceError.invalidResponse(status: http.statusCode, error: err)
        }
        do {
            let decoded = try JSONDecoder().decode(HomeFeedResponse.self, from: data)
            return decoded
        } catch {
            throw AroundYouServiceError.decodingError
        }
    }
} 
