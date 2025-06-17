//
//  ConfirmationViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//

import Foundation

class ConfirmSignUpViewModel: ObservableObject {
    
    @Published var email:String = ""
    @Published var password:String = ""
    @Published var isConfirmed:Bool = false
    @Published var errorMessage:String? = ""
    @Published var confirmationCode:String = ""
    
    
    
    func confirmSignUp(completion: @escaping (Bool, String?) -> Void) {
        
        print("email from view model: ", email)
        let request = ConfirmRequest(
            username: email,
            confirmationCode: confirmationCode
        )
        
        Task{
            do {
                let response = try await ConfirmSignUpService.shared.confirmSignUp(data: request)
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
}
