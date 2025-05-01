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
    
    
}
