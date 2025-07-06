//
//  AccountService.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/5/25.
//

import Foundation

struct AccountProfileResponse: Decodable {
    let success:Bool
    let message: String
    let userProfile: UserAccountModel
    let posts: [UserPostModel]
}



class AccountService {
    
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
}
