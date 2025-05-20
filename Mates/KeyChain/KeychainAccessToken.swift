//
//  KeychainAccessToken.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/20/25.
//

import Foundation

extension KeychainHelper {
    
    static let accessTokenService = "com.mates.accessToken"
    
    
    static func saveAccessToken(_ token: String) {
        
        if let data = token.data(using: .utf8){
            save(data, service: accessTokenService, account: "accessToken")
        }
    }
    
    static func loadAccessToken() -> String? {
        
        guard let accessToken = read(service: accessTokenService, account: "accessToken") else {
            return nil
        }
        
        return String(data: accessToken, encoding: .utf8)
    }
    
    static func deleteAccessToken() {
        delete(serivce: accessTokenService, account: "accessToken")
    }
}
