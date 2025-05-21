//
//  ForgotPasswordService.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/21/25.
//

import Foundation

struct ForgotRequest: Codable{
  let username:String
}

struct ForgotResponse: Codable{
    let success: Bool
    let message: String?
    let error: String?
}

class ForgotPasswordService {
    
    static let shared = ForgotPasswordService()
    private init(){}
    
    
    func handleForgotPassword(data: ForgotRequest) async throws -> ForgotResponse {
        
        //checks if the url is a valid url
        guard let url = URL(string: "http://localhost:4000/forgot-password") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(data)
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        let response = try JSONDecoder().decode(ForgotResponse.self, from: responseData)
        
        return response
    }
}
