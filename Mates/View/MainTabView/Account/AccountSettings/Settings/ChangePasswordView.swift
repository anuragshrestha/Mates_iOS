//
//  ChangePasswordView.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/12/25.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @State var currentPassword: String = ""
    @State var newPassword: String = ""
    @State var confirmNewPassword: String = ""
    @State var hideCurrentPassword: Bool = false
    @State var isSecure: Bool = false
    @State var isSecure2: Bool = false
    
    
    var body: some View {
        
        ZStack{
            
            Color.black.background().ignoresSafeArea()
            
            VStack{
                
                SecureTextField(password: $currentPassword, placeholder: "Enter your current password", isSecure: $hideCurrentPassword)
                    .padding(.bottom, 10)
                
                SecureTextField(password: $newPassword, placeholder: "Enter your new password", isSecure: $isSecure)
                    .padding(.bottom, 10)
                
                SecureTextField(password: $confirmNewPassword, placeholder: "Confirm your new password", isSecure: $isSecure2)
                    .padding(.bottom, 20)
                
              
                
                Button(action: {
                    print("button pressed")
                    //call the api to change the password
                }){
                    Text("Change Password")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.9))
                        .cornerRadius(12)
                }
                
                
                Spacer()
                
                
            }
            .padding(.top, 100)
            
         
        }
    }
}

#Preview {
    ChangePasswordView()
}
