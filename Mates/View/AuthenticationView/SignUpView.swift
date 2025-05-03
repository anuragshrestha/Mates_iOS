//
//  SignUpView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/17/25.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var signUpVM = SignupViewModel()
    @State var alertMessage:String = ""
    @State var showAlert:Bool = false
    
    
    var body: some View {
        
        ZStack{
            
            Color.black.ignoresSafeArea()
           
            
            ScrollView{
                VStack{
                    InputField(text: $signUpVM.email, placeholder: "Enter your school email")
                        .padding(.vertical, 10)
                    
                    InputField(text: $signUpVM.firstName, placeholder: "Enter your first name")
                        .padding(.vertical, 10)
                    
                    InputField(text: $signUpVM.lastName, placeholder: "Enter your last name")
                        .padding(.vertical, 10)
                    
                    SecureTextField(password: $signUpVM.password, placeholder: "Enter your password", isSecure: $signUpVM.isSecure)
                        .padding(.vertical, 10)
                    
                    
                    NavigationLink(destination: ConfirmView(email: signUpVM.email), isActive: $signUpVM.isSignUp){
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
                        if signUpVM.email.isEmpty{
                            showAlert = true
                            alertMessage = "Enter your school email"
                        }else if signUpVM.firstName.isEmpty {
                            showAlert = true
                            alertMessage = "Enter your first name"
                        }else if signUpVM.lastName.isEmpty {
                            showAlert = true
                            alertMessage = "Enter your last name"
                        }else if signUpVM.password.isEmpty {
                            showAlert = true
                            alertMessage = "Enter your password"
                        } else if !signUpVM.isValidEmail(_email: signUpVM.email) {
                            showAlert = true
                            alertMessage = "Enter a valid school email"
                        } else if !signUpVM.isValidPassword(_password: signUpVM.password){
                            showAlert = true
                            alertMessage = "Password must be at least 8 characters and have \n one upper, lower, digit and special character"
                        } else if signUpVM.universityName.isEmpty {
                            showAlert = true
                            alertMessage = "Select your university"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                  dismiss()
                              }
                        }else if signUpVM.major.isEmpty {
                            showAlert = true
                            alertMessage = "Select your major"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                dismiss()
                            }
                        }else if signUpVM.schoolYear.isEmpty {
                            showAlert = true
                            alertMessage = "Select your school year"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                dismiss()
                            }
                        }else{
                             signUpVM.signUp { success, message in
                                if success{
                                    DispatchQueue.main.async {
                                        signUpVM.isSignUp = true
                                    }
                                }else{
                                    alertMessage = message ?? "Signup failed"
                                    showAlert = true
                                }
                            }
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
