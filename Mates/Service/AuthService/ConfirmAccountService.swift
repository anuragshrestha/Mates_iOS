//
//  ConfirmAccountService.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/17/25.
//

//Service to handle the account confirmation when user tries to sign in whose account si not confirmed during sign up

import Foundation

struct ConfirmAccountRequest: Codable {
    let username:String
    let confirmationCode: String
}

struct ConfirmAccountResponse: Codable{
    let success:Bool
    let message:String?
    let error: String?
}

class ConfirmAccountService{
    
    static let shared = ConfirmAccountService()
    private init(){}
    
    func confirmAccount(data: ConfirmAccountRequest)async throws -> ConfirmAccountResponse{
        
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
        
        let response = try JSONDecoder().decode(ConfirmAccountResponse.self, from: responseData)
        return response
        
    }
}

