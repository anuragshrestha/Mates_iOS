//
//  AccountService.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/5/25.
//

import Foundation
import SwiftUICore

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


class AccountService {
    
 
    
    //Service for fetching account profile
    static func getAccountInfo(limit: Int = 2, offset: Int = 0, completion: @escaping (Bool, AccountProfileResponse?,  String?) -> Void) {
        
        //loads the access token from keychain
        guard let accessToken = KeychainHelper.loadAccessToken() else {
            completion(false, nil, "unauthorized user")
            return
        }
        
        
        //checks the url
        guard let url = URL(string: "\(Config.baseURL)/account?limit=\(limit)&offset=\(offset)") else{
            completion(false,nil, "Invalid url")
            return
        }
        
        //create a new http request
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: httpRequest) { data, response, error in
            
            if let error = error {
                completion(false, nil, error.localizedDescription)
                return
            }
            
            guard let data = data else{
                completion(false, nil, "no data found")
                return
            }
            
            guard response is HTTPURLResponse else{
                completion(false, nil, "Invalid response")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(AccountProfileResponse.self, from: data)
                completion(true, decodedResponse, nil)
            }catch {
                completion(false, nil, error.localizedDescription)
            }
            
        }
        .resume()
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
}
