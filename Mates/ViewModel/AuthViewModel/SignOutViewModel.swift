//
//  SignOutViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/19/25.
//

import Foundation
import SwiftUI


@MainActor
class SignOutViewModel:ObservableObject{
    
    @AppStorage("isSignedIn") var isSignedIn: Bool = false
    @Published var isSignedOut:Bool = false
    
    
    func signOut(completion: @escaping (Bool, String?) -> Void){
        
        Task{
            do{
                guard let token = KeychainHelper.loadAccessToken() else {
                    
                    KeychainHelper.deleteAccessToken()
                    isSignedIn = false
                    completion(true,nil)
                    return
                }
                
                    let request = SignOutRequest(accessToken: token)
                    let response = try await SignOutService.shared.signout(data: request)
                    
                
                    print("response: ", response)
                    if response.success {
                        print("removing access token")
                        KeychainHelper.deleteAccessToken()
                        isSignedIn = false
                        completion(true, nil)
                    } else{
                        completion(false, response.message)
                    }
                } catch{
                completion(false, error.localizedDescription)
            }
        }
    }
}
