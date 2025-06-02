//
//  SignInViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/17/25.
//

import Foundation
import SwiftUI


@MainActor
class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isSecure: Bool = false
    @Published var isSignedIn:Bool = false
    @AppStorage("isSignedIn") var isSigned: Bool = false
    
    
    ///Checks if the password meets the AWS cognito password requirement
    ///If the count is less than 8 or doesn't contain a upper, lower,digit or special character then
    ///it return false else true

    func isValidPassword(_password: String) -> Bool {
        
        guard password.count >= 6 else { return false}
        
        let uppercasePattern = ".*[A-Z]+.*"
        let lowercasePattern = ".*[a-z]+.*"
        let digitPattern = ".*[0-9]+.*"
        let specialCharPattern = ".*[!@#$%^&*(),.?\":{}|<>\\[\\]\\\\/;'_+=-]+.*"
        
        
        let uppercase = NSPredicate(format: "SELF MATCHES %@", uppercasePattern)
        let lowercase = NSPredicate(format: "SELF MATCHES %@", lowercasePattern)
        let digit = NSPredicate(format: "SELF MATCHES %@", digitPattern)
        let specialChar = NSPredicate(format: "SELF MATCHES %@", specialCharPattern)
        
        return uppercase.evaluate(with: password)
            && lowercase.evaluate(with: password)
            && digit.evaluate(with: password)
            && specialChar.evaluate(with: password)
        
        
    }
    
    
    //checks if the email is a valid school email
    func isValidEmail(_email: String) -> Bool {
        
        let pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.edu$"
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", pattern)
        
        return predicate.evaluate(with: email)
    }
    
    
    func signIn(completion: @escaping (Bool, String?) -> Void) {
        
        let request = SignInRequest(
           username: email,
           password: password
        )
        
        Task{
            do{
                let response = try await SignInService.shared.signInService(data: request)
                print("in signin viewmodel")
                if response.success {
                    
                    guard let accessToken = response.accessToken, !accessToken.isEmpty else {
                           print("Access token is missing even though success is true. Aborting.")
                           completion(false, "Login failed: missing token")
                           return
                       }
                    KeychainHelper.saveAccessToken(accessToken)
                    DispatchQueue.main.async{
                        self.isSigned = true
                    }
                    print("saved access token: \(String(describing: response.accessToken))")
                }
                print("response messsage \(String(describing: response.message))")
                print("response error \(String(describing: response.error))")
                DispatchQueue.main.async {
                    completion(response.success, response.message ?? response.error)
                }
               
            }catch{
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    
    func resendConfirmationCode(completion: @escaping (Bool, String?) -> Void){
        
        let request = ResendEmail(
            username: email
        )
        
        Task{
            do {
                let response = try await SignInService.shared.resendEmailConfirmation(data: request)
                completion(response.success, response.message ?? response.error)
            }catch{
                completion(false, error.localizedDescription)
            }
        }
    }
}


