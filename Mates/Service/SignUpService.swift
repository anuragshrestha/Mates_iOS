//
//  SignUpService.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/1/25.
//

import Foundation

struct SignUpRequest: Codable{
    let university_name: String
    let major: String
    let school_year: String
    let first_name: String
    let last_name: String
    let username: String
    let password: String
}


struct SignUpResponse: Codable{
    let success:Bool
    let message: String?
    let error: String?
}
    

class SignUpService{
    static let shared = SignUpService()
    private init(){}
    
    func signUpUser(data: SignUpRequest) async throws -> SignUpResponse {
        
        //check if the url is valid
        guard let url = URL(string: "http://127.0.0.1:4000/signup") else {
            throw URLError(.badURL)
        }
        
        //creates a HTTP request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
       
        request.httpBody = try JSONEncoder().encode(data)
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        let decodedResponse = try JSONDecoder().decode(SignUpResponse.self, from: responseData)
        return decodedResponse

    }
}
