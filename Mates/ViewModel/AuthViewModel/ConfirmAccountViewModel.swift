//
//  ConfirmAccountViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/17/25.
//

import Foundation


class ConfirmAccountViewModel: ObservableObject {
    
    @Published var email:String = ""
    @Published var tempPassword:String = ""
    @Published var isConfirmed:Bool = false
    @Published var errorMessage:String? = ""
    @Published var confirmationCode:String = ""
    
    
    
    func confirmAccount(completion: @escaping (Bool, String?) -> Void) {
        
        print("email from view model: ", email)
        let request = ConfirmAccountRequest(
            username: email,
            confirmationCode: confirmationCode
        )
        
        Task{
            do {
                let response = try await ConfirmAccountService.shared.confirmAccount(data: request)
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
