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
    @Published var confirmNewPassword:String = ""
    @Published var isConfirmed:Bool = false
    @Published var confirmationCode:String = ""
    @Published var isSecure:Bool = false
    @Published var isSecure2:Bool = false
    @Published var isConfirmedForgotPassword:Bool = false
    
    ///checks if the email is a valid school email
    func isValidEmail(_email: String) -> Bool {
        
        let pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.edu$"
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", pattern)
        
        return predicate.evaluate(with: email)
    }
    
    
    ///checks if the password fullfills the requirement 
    func isValidPassword(_ password: String) -> Bool {
        
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

    
    
    //checks if the new password matches with the confirm new password
    func checkPassword(password: String, confirmPassword:String) -> Bool {
        
        return password == confirmPassword
     
    }
    
    
    //calls the /forgot password api
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
    
    
    //confirms the forgot password
    func confirmForgotPassword(completion: @escaping(Bool, String?) -> Void) {
        
        let request = ConfirmForgotRequest(username: email, confirmationCode: confirmationCode, password: newPassword)
        
        Task{
            do{
                let response = try await ForgotPasswordService.shared.handleConfirmForgotPassword(data: request)
                DispatchQueue.main.async {
                    completion(response.success, response.message ?? response.error)
                }
            }catch{
                completion(false, error.localizedDescription)
            }
        }
    }
}
