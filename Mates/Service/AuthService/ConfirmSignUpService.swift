//
//  ConfirmSignUpService.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/1/25.
//


// confirm service that handles to confirm user email during signup

import Foundation

struct ConfirmRequest: Codable {
    let username:String
    let confirmationCode: String
}

struct ConfirmResponse: Codable{
    let success:Bool
    let message:String?
    let error: String?
}

class ConfirmSignUpService{
    
    static let shared = ConfirmSignUpService()
    private init(){}
    
    func confirmSignUp(data: ConfirmRequest)async throws -> ConfirmResponse{
        
        //checks if the url is a valid url
        guard let url = URL(string: "\(Config.baseURL)/confirm-Signup") else {
            throw URLError(.badURL)
        }
        
        //creates a HTTP request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(data)
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        let response = try JSONDecoder().decode(ConfirmResponse.self, from: responseData)
        return response
        
    }
}
