//
//  ChangePasswordService.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/18/25.
//

import Foundation


struct ChangePasswordRequest: Codable {
    
    let currentPassword: String
    let newPassword: String
}



class ChangePasswordService {
    
    static let shared = ChangePasswordService()
    private init(){}
    
    
     func changePassword(data: ChangePasswordRequest, completion: @escaping(Bool, String?) -> Void){
        
        guard let url = URL(string: "\(Config.baseURL)/change-password") else {
            completion(false, "Invalid url")
            return
        }
        
        
        guard let accessToken = KeychainHelper.loadAccessToken() else{
            completion(false, "Unauthorized")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(data)
        }catch {
            completion(false, "Failed to encode data")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, "Invalid response")
                return
            }
            
            if httpResponse.statusCode == 200 {
                      completion(true, nil)
                   } else {
                       completion(false, "Invalid status code")
            }
            
            
        }
        .resume()
        
        
    }
}
