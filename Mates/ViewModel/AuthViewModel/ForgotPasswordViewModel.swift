//
//  ForgotPasswordViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/21/25.
//

import Foundation


class ForgotPasswordViewModel: ObservableObject {
    
    @Published var email:String = ""
    @Published var newPassword:String = ""
    @Published var isConfirmed:Bool = false
    
    
    
    //checks if the email is a valid school email
    func isValidEmail(_email: String) -> Bool {
        
        let pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.edu$"
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", pattern)
        
        return predicate.evaluate(with: email)
    }
    
    
    func forgotPassword(completion: @escaping(Bool, String?) -> Void) {
        
        let request = ForgotRequest(username: email)
        
        Task{
            do{
                let response = try await ForgotPasswordService.shared.handleForgotPassword(data: request)
                DispatchQueue.main.async {
                    completion(response.success, response.message ?? response.error)
                }
            }catch{
                completion(false, error.localizedDescription)
            }
        }
    }
}
