
//
//  SignupViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/22/25.
//

import Foundation

class SignupViewModel:ObservableObject{
    
    @Published var email:String = ""
    @Published var firstName:String = ""
    @Published var lastName:String = ""
    @Published var password:String = ""
    @Published var isSecure:Bool = false
    @Published var universityName:String = ""
    @Published var major:String = ""
    @Published var schoolYear:String = ""
    
    
    
    ///Checks if the password meets the AWS cognito password requirement
    ///If the count is less than 8 or doesn't contain a upper, lower,digit or special character then
    ///it return false else true

    func isValidPassword(_password: String) -> Bool {
        
        guard password.count >= 8 else { return false}
        
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
    
    func signUp(completion: @escaping(Bool, String?) -> Void) {
        
        let request = SignUpRequest(
            university_name: universityName,
            major: major,
            school_year: schoolYear,
            first_name: firstName,
            last_name: lastName,
            username: email,
            password: password
        )
        
        Task{
            do {
                let response = try await SignUpService.shared.signUpUser(data: request)
                DispatchQueue.main.async{
                    completion(response.success, response.message ?? response.error)
                }
            }catch{
                DispatchQueue.main.async{
                    completion(false, error.localizedDescription)
                }
            }
        }
    }
    
}
