//
//  ChangePasswordView.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/12/25.
//

import SwiftUI

struct ChangePasswordView: View {
    
    
    @ObservedObject var changePasswordVM = ChangePasswordViewModel()
    @Environment(\.dismiss) var dismiss
    
   
    @State var hideCurrentPassword: Bool = false
    @State var isSecure: Bool = false
    @State var isSecure2: Bool = false
    @State var showAlert: Bool = false
    @State var alertMessage:String = ""
    @State var showSuccessAlert:Bool = false
    @State var isLoading:Bool = false
    
    
    
    var body: some View {
        
        ZStack{
            
            Color.black.background().ignoresSafeArea()
            
            VStack{
                
                SecureTextField(password: $changePasswordVM.currentPassword, placeholder: "Enter your current password", isSecure: $hideCurrentPassword)
                    .padding(.bottom, 10)
                
                SecureTextField(password: $changePasswordVM.newPassword, placeholder: "Enter your new password", isSecure: $isSecure)
                    .padding(.bottom, 10)
                
                SecureTextField(password: $changePasswordVM.confirmNewPassword, placeholder: "Confirm your new password", isSecure: $isSecure2)
                    .padding(.bottom, 20)
                
              
                
                Button(action: {
                    print("button pressed")
                    
                    if changePasswordVM.currentPassword.isEmpty {
                        alertMessage = "Enter your current password"
                        showAlert = true
                    }else if changePasswordVM.newPassword.isEmpty{
                        alertMessage = "Enter your new password"
                        showAlert = true
                    }else if changePasswordVM.confirmNewPassword.isEmpty{
                        alertMessage = "Confirm your new password"
                        showAlert = true
                    } else if !changePasswordVM.isValidPassword(changePasswordVM.newPassword) || !changePasswordVM.isValidPassword(changePasswordVM.confirmNewPassword){
                        alertMessage = "Password must be at least 6 characters and have \n one upper, lower, digit and special character"
                        showAlert = true
                    } else if !changePasswordVM.checkPassword(password: changePasswordVM.newPassword, confirmPassword: changePasswordVM.confirmNewPassword){
                        alertMessage = "Confirm password doesnot match with new password"
                        showAlert = true
                    }else{
                        isLoading = true
                        
                        //api call to change the password
                        changePasswordVM.changePassword { success, message in
                            isLoading = false
                            DispatchQueue.main.async {
                                if success {
                                    showSuccessAlert = true
                                }else {
                                    alertMessage = message ?? "Failed to change password"
                                    showAlert = true
                                }
                            }
                        }
                    }
                
                }){
                    Text("Change Password")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.9))
                        .cornerRadius(12)
                }
                .alert("Error", isPresented: $showAlert) {
                    Button("Ok", role: .cancel){}
                }message: {
                    Text(alertMessage)
                }
                .alert("Success", isPresented: $showSuccessAlert){
                    Button("Ok"){
                        dismiss()
                    }
                } message: {
                    Text("Successfully changed password")
                }
                
                
                Spacer()
                
            }
            .padding(.top, 100)
            
            
            if isLoading {
                
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
    
    }
}

#Preview {
    ChangePasswordView()
}
