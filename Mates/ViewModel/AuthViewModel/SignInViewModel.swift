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
}
