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
    
    
}
