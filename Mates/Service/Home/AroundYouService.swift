//
//  AroundYouService.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/18/25.
//

import Foundation

struct HomeFeedResponse: Decodable {
    
    let success: Bool
    let user: UserModel
    let posts: [PostModel]
}

enum AroundYouServiceError: Error {
    
    case unauthorized
    case nodata
    case invalidResponse(status:Int, error: String)
    case urlError
    case decodingError
}

class AroundYouService {
    
    static let shared = AroundYouService()
    private init(){}
    
    func fetchHomeFeed() async throws -> HomeFeedResponse {
        
        
        //checks if there is a access token
        guard let accessToken = KeychainHelper.loadAccessToken() else {
            throw AroundYouServiceError.unauthorized
        }
        
        
        //checks if its a valid url
        guard let url = URL(string: "\(Config.baseURL)/aroundyou-feed") else {
            throw AroundYouServiceError.urlError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("no http response")
                throw AroundYouServiceError.invalidResponse(status: -1, error: "No HTTP Response")
            }
            
            if httpResponse.statusCode == 200 {
                print("successfully fetched data ", "status code: \(httpResponse.statusCode)", data)
                do {
                    let decodedResponse = try JSONDecoder().decode(HomeFeedResponse.self, from: data)
                    print("successfully decoded  \(decodedResponse)")
                         return decodedResponse
                }catch {
                    print("decoding error")
                    throw AroundYouServiceError.decodingError
                }
            }else{
              print("error: invalid http response")
                let error = (try? JSONDecoder().decode([String: String].self, from: data)["error"]) ?? "Unknow error"
                throw AroundYouServiceError.invalidResponse(status: httpResponse.statusCode, error: error)
            }
        }catch {
            throw error
        }
    
    }
}
