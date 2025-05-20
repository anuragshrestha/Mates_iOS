//
//  KeychainHelper.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/20/25.
//

import Foundation
import Security


struct KeychainHelper{
    
    ///All the functions are static because they are state less.
    ///We don't want to depend on any instance variables and instantiate Keychain helper
    ///This function saves binary data to the Keychain.
    ///   Parameters:
    ///  *  data: the value we want to save (must be Data type).
    ///  *  service: a custom string to identify the app’s Keychain entry.
    ///  *  account: a name for the data entry (e.g., "accessToken").
    
    static func save(_ data:Data, service: String, account: String){
        
        
        ///  This creates a dictionary query to pass to the Keychain API.
        ///  kSecClassGenericPassword says this is a password-type item (standard for tokens).
        ///  kSecAttrService: groups related credentials (e.g., all belonging to the app).
        ///  kSecAttrAccount: like a key name, identifies the specific item.
        ///  kSecValueData: the actual data being saved.
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecValueData: data
        ] as CFDictionary
        
        SecItemDelete(query)
        SecItemAdd(query, nil)
    }
    
    
    ///  Query to fetch a single Keychain item.
    ///  kSecReturnData: true tells it to return the actual value (not just metadata).
    ///  kSecMatchLimitOne: returns the first match only.
    ///  SecItemCopyMatching: tries to find the item and stores the result in result.
    ///  If found, it is cast back to Data and returned.
    ///  If not found, returns nil.
    
    static func read(service: String, account: String) -> Data? {
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        return result as? Data
    }
    
    
    
    static func delete(serivce: String, account: String) {
        
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serivce,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        SecItemDelete(query)
    }
    
    
    
    
}
