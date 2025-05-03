//
//  SignInViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/17/25.
//

import Foundation

class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isSecure: Bool = false
    @Published var isSignedIn:Bool = false
    
    func signIn(completion: @escaping (Bool, String?) -> Void) {
        
        let request = SignInRequest(
           username: email,
           password: password
        )
        
        Task{
            do{
                let response = try await SignInService.shared.signInService(data: request)
                completion(response.success, response.message ?? response.error)
            }catch{
                completion(false, error.localizedDescription)
            }
        }
    }
}


