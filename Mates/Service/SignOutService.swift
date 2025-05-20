//
//  SignOutService.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/19/25.
//

import Foundation

struct SignOutRequest: Codable {
    let accessToken:String
}

struct SignOutResponse: Codable{
    let success:Bool
    let message:String?
}

class SignOutService {
    
    static let shared = SignOutService()
    private init(){}
    
    
    func signout(data:SignOutRequest) async throws -> SignOutResponse {
        
        guard let url = URL(string: "http://localhost:4000/signout") else{
            throw  URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(data.accessToken )", forHTTPHeaderField: "Authorization")
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        let decodedData = try JSONDecoder().decode(SignOutResponse.self, from: responseData)
        
        return decodedData
    }
    
    
    
}
