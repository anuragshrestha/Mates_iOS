//
//  FollowUnFollowService.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/29/25.
//

import Foundation


struct FollowUnfollowResponse: Decodable {
    let success: Bool
    let message: String?
    let error: String?
}


class FollowUnfollowUser {
    
    static let shared = FollowUnfollowUser()
    private init(){}
    
    
    //follows the user with userId
    func followUser(userId: String, completion: @escaping(Bool, String?) -> Void){
        
        guard let accessToken = KeychainHelper.loadAccessToken() else {
            completion(false, "No access token")
            return
        }
        
        guard let url = URL(string: "\(Config.baseURL)/users/\(userId)/follow") else {
            completion(false, "Invalid url")
            return
        }
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        httpRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: httpRequest) { data, response, error in
            
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
      
            guard let data = data else{
                completion(false, "No data found")
                return
            }
            
            do{
                let decodedResponse = try JSONDecoder().decode(FollowUnfollowResponse.self, from: data)
                if decodedResponse.success{
                    completion(true, nil)
                }else{
                    completion(false, decodedResponse.error ?? "Unknown error")
                }
            }catch{
                completion(false, error.localizedDescription)
            }
        }
        .resume()
    }
    
    
    
    //Unfollows the user with userId
    func unFollowUser(userId: String, completion: @escaping(Bool, String?) -> Void) {
        
        guard let accessToken = KeychainHelper.loadAccessToken() else {
            completion(false, "No access token found")
            return
        }
        
        guard let url = URL(string: "\(Config.baseURL)/users/\(userId)/follow") else {
            completion(false, "Invalid url")
            return
        }
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "DELETE"
        httpRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: httpRequest) { data, response, error in
            
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
    
            guard let data = data else {
                completion(false, "No data found")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(FollowUnfollowResponse.self, from: data)
                
                if decodedResponse.success {
                    completion(true, nil)
                }else{
                    completion(false, error?.localizedDescription ?? "Failed to unfollow user")
                }
            }catch{
                completion(false, error.localizedDescription)
                
            }
        }
        .resume()
        
        
        
    }
}
