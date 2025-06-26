//
//  SearchUserService.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/25/25.
//

import Foundation


struct SearchResponse: Decodable {
    let success: Bool
    let users: [UserModel]
}

class SearchUserService {
    static func fetchUser(for query: String, completion: @escaping (Result<[UserModel], Error>) -> Void) {
        
        guard let encodingQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "http://localhost:4000/search-user?query=\(encodingQuery)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do{
                let decoded = try JSONDecoder().decode(SearchResponse.self, from: data)
                completion(.success(decoded.users))
            }catch{
                completion(.failure(error))
            }
        }
        .resume()
    }
}
