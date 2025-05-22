//
//  ForgotPasswordView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/17/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @StateObject var forgotPasswordVM = ForgotPasswordViewModel()
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    
    var body: some View {
        VStack {
            
            InputField(text: $forgotPasswordVM.email, placeholder: "Enter your email")
            
            NavigationLink(destination: ResetPasswordScreen(forgotVM: forgotPasswordVM), isActive: $forgotPasswordVM.isConfirmed) {
                CustomButton(title: "Send verification code") {
                    print("pressed code")
                    
                    if forgotPasswordVM.email.isEmpty{
                        showAlert = true
                        alertMessage = "Please enter your email"
                    }else if !forgotPasswordVM.isValidEmail(_email: forgotPasswordVM.email){
                        showAlert = true
                        alertMessage = "Invalid email"
                    } else{
                        forgotPasswordVM.forgotPassword { success, message in
                            if success{
                                forgotPasswordVM.isConfirmed = true
                            }else{
                                showAlert = true
                                alertMessage = message ?? "Failed to send code"
                            }
                        }
                    }
                }
                .alert("Missing email", isPresented: $showAlert){
                    Button("Ok", role: .cancel) {}
                } message: {
                    Text(alertMessage)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
    }
}

#Preview {
    NavigationView {
        ForgotPasswordView()
    }
   
}
