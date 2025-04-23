//
//  SignUpView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/17/25.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject var signupVM = SignupViewModel()
    
    var body: some View {
        
        VStack{
            VStack{
                InputField(text: $signupVM.email, placeholder: "Enter your school email")
                    .padding(.vertical, 10)
                
                InputField(text: $signupVM.firstName, placeholder: "Enter your first name")
                    .padding(.vertical, 10)
                
                InputField(text: $signupVM.lastName, placeholder: "Enter your last name")
                    .padding(.vertical, 10)
                
                SecureTextField(password: $signupVM.password, placeholder: "Enter your password", isSecure: $signupVM.isSecure)
                    .padding(.vertical, 20)
                
                CustomButton(title: "Sign UP",color: .blue) {
                    print("pressed signup button")
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            
           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color.black)
        .navigationTitle("")
    }
}

#Preview {
    SignUpView()
}
