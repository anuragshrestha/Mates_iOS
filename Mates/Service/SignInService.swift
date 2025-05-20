//
//  SignInService.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/2/25.
//

import Foundation

struct SignInRequest:Codable {
    let username:String
    let password:String
}

struct SignInResponse: Codable {
    let success: Bool
    let message: String?
    let accessToken: String
    let idToken: String?
    let refreshToken: String?
    let expiresIn: Int?
    let tokenType: String?
    let error: String?
}

struct ResendEmail:Codable{
    let username:String
}

struct ResendEmailResponse: Codable {
    let success:Bool
    let message:String?
    let error:String?
}

class SignInService{
    
    
    //creates a single shared instance of SignInService
    static let shared = SignInService()
    private init(){}
    
    
    ///checks if the url is a valid url
    ///create a HTTP request and adds the method, value.
    ///Encodes the swift types into json and add the body
    ///sends the request using new URL Session
    ///decode the response and return it
    func signInService(data:SignInRequest)  async throws -> SignInResponse {
        
        //checks if the url is a valid url
        guard let url = URL(string: "http://127.0.0.1:4000/signin") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(data)
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        let decodedData = try JSONDecoder().decode(SignInResponse.self, from: responseData)
        return decodedData
        
    }
    
    
    func resendEmailConfirmation(data:ResendEmail) async throws -> ResendEmailResponse {
        
        guard let url = URL(string: "http://127.0.0.1:4000/resend-confirmation-code") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(data)
        
        let (response, _) = try await URLSession.shared.data(for: request)
        
        let decodedResponse = try JSONDecoder().decode(ResendEmailResponse.self, from: response)
        return decodedResponse
    }
}
