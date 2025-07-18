//
//  ChangePasswordViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/18/25.
//

import Foundation


class ChangePasswordViewModel: ObservableObject {
    
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmNewPassword: String = ""
    
    
    
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
    
    
    func changePassword(completion: @escaping(Bool, String?) -> Void ){
        
        let request = ChangePasswordRequest(currentPassword: currentPassword, newPassword: newPassword)
        
        ChangePasswordService.shared.changePassword(data: request) { success, message in
                    DispatchQueue.main.async{
                       completion(success, message)
            }
                
        }
    }
    
}
