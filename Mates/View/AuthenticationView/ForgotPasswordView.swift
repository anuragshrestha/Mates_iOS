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
    @State private var isLoading:Bool = false
    
    var body: some View {
        
        ZStack{
            VStack {
                
                InputField(text: $forgotPasswordVM.email, placeholder: "Enter your email")
                
                
                CustomButton(title: "Send verification code") {
                    print("pressed code")
                    
                    if forgotPasswordVM.email.isEmpty{
                        showAlert = true
                        alertMessage = "Please enter your email"
                    }else if !forgotPasswordVM.isValidEmail(_email: forgotPasswordVM.email){
                        showAlert = true
                        alertMessage = "Invalid email"
                    } else{
                        isLoading = true
                        forgotPasswordVM.forgotPassword { success, message in
                            isLoading = false
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .ignoresSafeArea()
            .navigationDestination(isPresented: $forgotPasswordVM.isConfirmed) {
                ResetPasswordScreen(forgotVM: forgotPasswordVM)
            }
            
            
            //Shows Progress view until we get response from backend after sending the request
            if isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ForgotPasswordView()
    }
   
}
