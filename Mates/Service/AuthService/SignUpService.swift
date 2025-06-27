//
//  SignUpService.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/1/25.
//

import Foundation
import _PhotosUI_SwiftUI

struct SignUpRequest {
    let university_name: String
    let major: String
    let school_year: String
    let first_name: String
    let last_name: String
    let username: String
    let image: UIImage
    let password: String
}


struct SignUpResponse: Codable{
    let success:Bool
    let message: String?
    let error: String?
}
    

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}



class SignUpService{
    static let shared = SignUpService()
    private init(){}
    
    func signUpUser(data: SignUpRequest) async throws -> SignUpResponse {
        
        //check if the url is valid
        guard let url = URL(string: "\(Config.baseURL)/signup") else {
            throw URLError(.badURL)
        }
        
        //creates a HTTP request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
 
        let body = createMultipartBody(data: data, boundary: boundary)
        request.httpBody = body
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        
        let decodedResponse = try JSONDecoder().decode(SignUpResponse.self, from: responseData)
        

        return decodedResponse

    }
    

    private func createMultipartBody(data: SignUpRequest, boundary: String) -> Data {
        
     
        
        var body = Data()

        let parameters: [String: String] = [
            "university_name": data.university_name,
            "major": data.major,
            "school_year": data.school_year,
            "first_name": data.first_name,
            "last_name": data.last_name,
            "username": data.username,
            "password": data.password
        ]

        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        // Add image
        if let imageData = data.image.jpegData(compressionQuality: 0.8) {
            let filename = "profile.jpg"
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: image/jpeg\r\n\r\n")
            body.append(imageData)
            body.append("\r\n")
        }

        body.append("--\(boundary)--\r\n")
        return body
    }
    

}
