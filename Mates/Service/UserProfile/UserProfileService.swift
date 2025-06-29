//
//  UserProfileService.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/28/25.
//

import Foundation

class UserProfileService{
    
    
    static let shared = UserProfileService()
    private init(){}
    
    func fetchUserProfile(userId: String, completion: @escaping (Result<UserProfileResponse, Error>) -> Void) {
        
        
        //extracts the access token
        guard let accessToken = KeychainHelper.loadAccessToken() else{
            completion(.failure(NSError(domain: "", code: 401)))
            return
        }
        
        
        //checks if the url is valid
        guard let url = URL(string: "\(Config.baseURL)/users/\(userId)/profile") else {
            completion(.failure(NSError(domain: "", code: 400)))
            return
        }
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: httpRequest){ data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else{
                completion(.failure(NSError(domain: "", code: 500)))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(UserProfileResponse.self, from: data)
                completion(.success(decodedResponse))
            }catch{
                completion(.failure(error))
            }
            
        }
        .resume()
        
        
    }
    
}
