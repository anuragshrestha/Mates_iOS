//
//  SignUpView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/17/25.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var signupVM = SignupViewModel()
    @State var signUp:Bool = false
    @State var alertMessage:String = ""
    @State var showAlert:Bool = false
    
    
    var body: some View {
        
        ZStack{
            
            Color.black.ignoresSafeArea()
           
            
            ScrollView{
                VStack{
                    InputField(text: $signupVM.email, placeholder: "Enter your school email")
                        .padding(.vertical, 10)
                    
                    InputField(text: $signupVM.firstName, placeholder: "Enter your first name")
                        .padding(.vertical, 10)
                    
                    InputField(text: $signupVM.lastName, placeholder: "Enter your last name")
                        .padding(.vertical, 10)
                    
                    SecureTextField(password: $signupVM.password, placeholder: "Enter your password", isSecure: $signupVM.isSecure)
                        .padding(.vertical, 10)
                    
                    
                    NavigationLink(destination: ConfirmSignUpView(), isActive: $signUp){
                        EmptyView()
                    }
                    
                    HStack {
                        Text("By continuing you agree to our ")
                            .font(.customfont(.semibold, fontSize: 20))
                            .foregroundColor(.white) +
                        Text("terms of Service ")
                            .font(.customfont(.semibold, fontSize: 20))
                            .foregroundColor(.blue) +
                        Text("and ")
                            .font(.customfont(.semibold, fontSize: 20))
                            .foregroundColor(.white) +
                        Text("Privacy Policy.")
                            .font(.customfont(.semibold, fontSize: 20))
                            .foregroundColor(.blue)
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal,12)
                    
                    CustomButton(title: "Sign up",color: .blue) {
                        
                        
                        //checks if any of the Input field is empty
                        if signupVM.email.isEmpty{
                            showAlert = true
                            alertMessage = "Enter your school email"
                        }else if signupVM.firstName.isEmpty {
                            showAlert = true
                            alertMessage = "Enter your first name"
                        }else if signupVM.lastName.isEmpty {
                            showAlert = true
                            alertMessage = "Enter your last name"
                        }else if signupVM.password.isEmpty {
                            showAlert = true
                            alertMessage = "Enter your password"
                        } else if !signupVM.isValidEmail(_email: signupVM.email) {
                            showAlert = true
                            alertMessage = "Enter a valid school email"
                        } else if !signupVM.isValidPassword(_password: signupVM.password){
                            showAlert = true
                            alertMessage = "Password must be at least 8 characters and have \n one upper, lower, digit and special character"
                        } else{
                            signUp = true
                        }
                    }
                    .alert("Missing Info", isPresented: $showAlert){
                        Button("Ok", role: .cancel) {}
                    } message: {
                        Text(alertMessage)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                  }
                .padding(.top, 100)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                    }
                }
            }
       
    }
}

#Preview {
    NavigationView {
        SignUpView()
    }
}
