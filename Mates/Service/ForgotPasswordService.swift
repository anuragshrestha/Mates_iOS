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


struct ConfirmForgotRequest: Codable{
    let username: String
    let confirmationCode: String
    let password:String
}


struct ConfirmForgotResponse: Codable{
    let success:Bool
    let message: String?
    let error:String?
}

class ForgotPasswordService {
    
    static let shared = ForgotPasswordService()
    private init(){}
    
    
    
    //Makes API call for the forgot password
    func handleForgotPassword(data: ForgotRequest) async throws -> ForgotResponse {
        
        //checks if the url is a valid url
        guard let url = URL(string: "http://10.0.0.225:4000/forgot-password") else {
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
    
    
    //Makes API call for confirm forgot password
    func handleConfirmForgotPassword(data: ConfirmForgotRequest) async throws -> ConfirmForgotResponse {
        
        guard let url = URL(string: "http://10.0.0.225:4000/confirm-forgot-password") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(data)
        
        let (response, _) = try await URLSession.shared.data(for: request)
        
        let decodeResponse = try JSONDecoder().decode(ConfirmForgotResponse.self, from: response)
        
        return decodeResponse
    }
}
