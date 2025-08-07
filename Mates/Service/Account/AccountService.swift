//
//  AccountService.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/5/25.
//

import Foundation
import SwiftUICore
import _PhotosUI_SwiftUI

struct AccountProfileResponse: Decodable {
    let success:Bool
    let message: String
    let userProfile: UserAccountModel
    let posts: [UserPostModel]
}

struct FeedBackRequest: Encodable{
    
    let message: String
}

struct FeedBackResponse: Decodable {
    
    let success:Bool
    let message: String?
    let error: String?
}

struct HelpSupportRequest: Encodable{
    let email: String
    let message: String
}

struct HelpSupportResponse: Decodable{
    let success:Bool
    let message:String?
    let error:String?
}

struct UpdateProfileRequest{
    
    let bio: String
    let major: String
    let school_year: String
    let full_name: String
    let image: UIImage?
}

struct UpdateProfileResponse: Decodable{
    let success:Bool
    let message: String?
    let error: String?
}



class AccountService {
    
 
    
    //Service for fetching account profile
    static func getAccountInfo(limit: Int = 2, offset: Int = 0) async -> Result<AccountProfileResponse, Error> {
        
        guard let accessToken = KeychainHelper.loadAccessToken() else {
            return .failure(URLError(.userAuthenticationRequired))
        }
        
        guard let url = URL(string: "\(Config.baseURL)/account?limit=\(limit)&offset=\(offset)") else {
            return .failure(URLError(.badURL))
        }
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
   
            let (data, response) = try await URLSession.shared.data(for: httpRequest)
            
            guard response is HTTPURLResponse else {
                return .failure(URLError(.badServerResponse))
            }
            
       
            let decodedResponse = try JSONDecoder().decode(AccountProfileResponse.self, from: data)
            return .success(decodedResponse)
            
        } catch {
            return .failure(error)
        }
    }
    
    
    
    
    
    //sends feedback message
     static func sendFeedBack(request: FeedBackRequest, completion: @escaping(Bool, String?) -> Void ){
        
        
        guard let accessToken = KeychainHelper.loadAccessToken() else {
            completion(false, "Unathorized user")
            return
        }
        
        guard let url = URL(string: "\(Config.baseURL)/account/feedback") else {
            completion(false, "Invalid url")
            return
        }
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        httpRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        httpRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
       
        do{
            httpRequest.httpBody = try JSONEncoder().encode(request)
        }catch {
            completion(false, "Failed to encode data")
            return
        }
        
         
         URLSession.shared.dataTask(with: httpRequest) { data, response, error in
             
             if let error = error {
                 completion(false, error.localizedDescription)
                 return
             }
             
             guard let response = response as? HTTPURLResponse else {
                 completion(false, "Invalid response")
                 return
             }
             
             if response.statusCode == 200 {
                 completion(true, nil)
             }else if let data = data ,
                      let error = try? JSONDecoder().decode(FeedBackResponse.self, from: data),
                      let errorMessage = error.error ?? error.message {
                 completion(false, errorMessage)
             } else {
                 completion(false, "Failed to send feedback")
               
             }
             
         }
         .resume()
    }
    
    
    //sends help and support message
    static func sendHelpSupport(request: HelpSupportRequest, completion: @escaping(Bool, String?) -> Void){
        
        guard let accessToken = KeychainHelper.loadAccessToken() else {
            completion(false, "Unauthorized")
            return
        }
        
        guard let url = URL(string: "\(Config.baseURL)/account/help-support") else {
            completion(false, "Invalid url")
            return
        }
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "POST"
        httpRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        httpRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        do {
            httpRequest.httpBody = try JSONEncoder().encode(request)
        }catch {
            completion(false, "Failed to encode data")
            return
        }
        
        URLSession.shared.dataTask(with: httpRequest){ data, response, error in
            
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
            }else if let data = data,
                     let err = try? JSONDecoder().decode(HelpSupportResponse.self, from: data),
                     let errorMessage = err.error ?? err.message{
                completion(false, errorMessage)
            }else{
                completion(false, "Failed to sent request")
            }
            
        }
        .resume()
    }
    
    
    
    //calls the api to update the profile
    static func updateProfile(data: UpdateProfileRequest, completion: @escaping(Bool, String?) -> Void) {
        
        
        guard let accessToken = KeychainHelper.loadAccessToken() else {
            completion(false, "Unauthorized")
            return
        }
        
        guard let url = URL(string: "\(Config.baseURL)/account/edit-profile") else {
            completion(false, "Invalid url")
            return
        }
        
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "PUT"
        
        let boundary = UUID().uuidString
        httpRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        httpRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        
 
        let body = createMultipartBody(data: data, boundary: boundary)
        httpRequest.httpBody = body

        
        URLSession.shared.dataTask(with: httpRequest){ data, response, error in
            
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
            }else if let data = data,
                     let err = try? JSONDecoder().decode(UpdateProfileResponse.self, from: data),
                     let errorMessage = err.error ?? err.message{
                completion(false, errorMessage)
            }else{
                completion(false, "Failed to update Profile")
            }
            
        }
        .resume()
    }
    
    
    
    
    //creates multipart form data to send to the backend
    static func createMultipartBody(data: UpdateProfileRequest, boundary: String) -> Data {
        
    
        var body = Data()

        let parameters: [String: String] = [
            "bio": data.bio,
            "major": data.major,
            "school_year": data.school_year,
            "full_name": data.full_name,
        ]

        for (key, value) in parameters {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }

        // Add image
        if let imageData = data.image?.jpegData(compressionQuality: 1.0) {
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
