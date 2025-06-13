
//
//  SignupViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/22/25.
//

import Foundation
import _PhotosUI_SwiftUI
import UIKit


class SignupViewModel:ObservableObject{
    
    @Published var email:String = ""
    @Published var firstName:String = ""
    @Published var lastName:String = ""
    @Published var password:String = ""
    @Published var isSecure:Bool = false
    @Published var universityName:String = ""
    @Published var major:String = ""
    @Published var schoolYear:String = ""
    
    @Published var selectedItem:PhotosPickerItem? = nil
    @Published var selectedImage:UIImage? = nil
    
    
    
    ///Checks if the password meets the AWS cognito password requirement
    ///If the count is less than 8 or doesn't contain a upper, lower,digit or special character then
    ///it return false else true

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
    
    
    //checks if the email is a valid school email
    func isValidEmail(_email: String) -> Bool {
        
        let pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.edu$"
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", pattern)
        
        return predicate.evaluate(with: email)
    }
    
    func signUp(completion: @escaping(Bool, String?) -> Void) {
        
        
        print("hit signup api in viewmodel")
        
        guard let image = selectedImage else {
            completion(false, "Profile image is required")
            return
        }
        
        let resizedImage = resizeImage(image)
        
        
        let request = SignUpRequest(
            university_name: universityName,
            major: major,
            school_year: schoolYear,
            first_name: firstName,
            last_name: lastName,
            username: email,
            image: resizedImage,
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
    
    

    func resizeImage(_ image: UIImage, maxDimension: CGFloat = 512) -> UIImage {
        let size = image.size
        let aspectRatio = size.width / size.height

        var newSize: CGSize
        if aspectRatio > 1 {
            // Landscape
            newSize = CGSize(width: maxDimension, height: maxDimension / aspectRatio)
        } else {
            // Portrait or square
            newSize = CGSize(width: maxDimension * aspectRatio, height: maxDimension)
        }

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
