//
//  LikeUnlikeService.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/21/25.
//

import Foundation

struct likeUnlikeRequest{
    let post_id: String
}

struct likeUnlikeResponse {
    let success: Bool
    let message: String?
    let error: String?
}


class LikeUnlikeService {
    
    static let shared = LikeUnlikeService()
    private init(){}
    
    
    func likePost(request: likeUnlikeRequest, completion: @escaping (Bool, String?) -> Void) {
        
        print("user liked the post \(request.post_id)")
        
        
        //loads the access token
        guard let accessToken = KeychainHelper.loadAccessToken() else {
            completion(false, "Access token not found")
            return
        }
        
        guard let url = URL(string: "\(Config.baseURL)/posts/\(request.post_id)/like") else{
            completion(false, "Invalid url")
            return
        }
    
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                completion(false, "Network error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else{
                completion(false, "Invalid response type")
                return
            }
            
            if  httpResponse.statusCode == 200 {
               completion(true, nil)
            }else{
                completion(false, "Invalid response code")
                return
            }
            
        }
        .resume()
    }


    func unlikePost(request: likeUnlikeRequest, completion: @escaping (Bool, String?) -> Void){
        
        print("user unliked the post \(request)")
        
        
        guard let accessToken = KeychainHelper.loadAccessToken() else{
            completion(false, "Failed to load access token")
            return
        }
        
        guard let url = URL(string: "\(Config.baseURL)/posts/\(request.post_id)/like") else {
            completion(false, "Invalid url string")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
//        let body: [String : Any] = ["post_id" : request.post_id]
//        
//        do {
//            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
//        }catch {
//            completion(false, "Failed to parse the data into json")
//            return
//        }
//        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let httpresponse = response as? HTTPURLResponse else {
                completion(false, "Not a http response")
                return
            }
            
            if httpresponse.statusCode == 200 {
                completion(true, nil)
            }else{
                completion(false, "Failed to unlike the post")
                return
            }
            
        }
        .resume()
        
        
    }

}


