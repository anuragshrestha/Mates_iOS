//
//  ResetPasswordScreen.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/21/25.
//

import SwiftUI

struct ResetPasswordScreen: View {
    
    @ObservedObject var forgotVM = ForgotPasswordViewModel()
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State private var showSuccessAlert:Bool = false
    
    var body: some View {
       
        VStack{
            
            InputField(text: $forgotVM.confirmationCode, placeholder: "Enter confirmation code")
                .padding(.bottom, 10)
            
            
            SecureTextField(password: $forgotVM.newPassword, placeholder: "Enter new password", isSecure: $forgotVM.isSecure)
                .padding(.bottom, 10)
  
            SecureTextField(password: $forgotVM.confirmNewPassword, placeholder: "Confirm the password", isSecure: $forgotVM.isSecure2)
                .padding(.bottom, 10)
            
          
                CustomButton(title: "Reset Password") {
                    if forgotVM.confirmationCode.isEmpty {
                        alertMessage = "Enter confirmation code"
                        showAlert = true
                    } else if forgotVM.newPassword.isEmpty {
                        showAlert = true
                        alertMessage = "Enter the new password"
                    } else if forgotVM.confirmNewPassword.isEmpty{
                        showAlert = true
                        alertMessage = "Enter the confirm password"
                    } else if !forgotVM.isValidPassword(forgotVM.newPassword) || !forgotVM.isValidPassword(forgotVM.confirmNewPassword){
                        alertMessage = "Password must be at least 6 characters and have \n one upper, lower, digit and special character"
                        showAlert = true
                    } else if !forgotVM.checkPassword(password: forgotVM.newPassword, confirmPassword: forgotVM.confirmNewPassword){
                        alertMessage = "Confirm password doesnot match with new password"
                        showAlert = true
                    } else {
                        forgotVM.confirmForgotPassword { success, message in
                            if success{
                                showSuccessAlert = true
                            }else{
                                alertMessage = message ?? "Failed to reset password"
                                showAlert = true
                            }
                        }
                    }
                }
                .alert("Error", isPresented: $showAlert) {
                    Button("Ok", role: .cancel){}
                }message: {
                    Text(alertMessage)
                }
                .padding(.horizontal, 20)
                .alert("Success", isPresented: $showSuccessAlert) {
                    Button("Ok"){
                        forgotVM.isConfirmedForgotPassword = true
                    }
                }message: {
                    Text("Successfully reset password")
                }
              
            Spacer()
        }
        .padding(.top, 200)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
        .navigationDestination(isPresented: $forgotVM.isConfirmedForgotPassword) {
            SignInView()
        }
    }
}

#Preview {
    
    NavigationStack {
        ResetPasswordScreen()
    }
}
