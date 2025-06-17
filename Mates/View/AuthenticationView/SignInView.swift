//
//  SignInView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/17/25.
//

import SwiftUI

/// A SwiftUI view responsible for rendering the sign-in screen for the Mates app.
///
/// Features:
/// - Custom welcome title
/// - Email and password input fields
/// - "Forgot Password" button
/// - Custom sign-in button
/// - Bottom navigation to sign-up page
///
/// Layout is vertically stacked and optimized for mobile view with proper spacing, styling, and safe area handling.

struct SignInView: View {
    
    
    @StateObject var signInVM = SignInViewModel()
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State var isConfirmed:Bool = false
    @State private var isLoading:Bool = false
  
    
    

    var body: some View {
        
        ZStack{
            VStack {
                Text("Welcome to Mates")
                    .font(.customfont(.semibold, fontSize: 36))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 150)
                
                Spacer().frame(height: 100)
                
                VStack {
                    InputField(text: $signInVM.email, placeholder: "Enter your school email")
                        .padding(.vertical, 10)
                    
                    SecureTextField(password: $signInVM.password, placeholder: "Enter your password", isSecure: $signInVM.isSecure)
                    
                    HStack{
                        
                        Spacer()
                        NavigationLink(destination: ForgotPasswordView()){
                            Text("Forgot Password?")
                                .foregroundColor(.blue)
                                .font(.customfont(.bold, fontSize: 20))
                        }
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                    
                    
         
                    
                    CustomButton(title: "Sign In", color: .blue) {
                        print("Pressed sign in")
                        if signInVM.email.isEmpty {
                            showAlert = true
                            alertMessage = "Please enter your email"
                        }else if signInVM.password.isEmpty {
                            showAlert = true
                            alertMessage = "Please enter your password"
//                        }else if !signInVM.isValidEmail(_email: signInVM.email){
//                            showAlert = true
//                            alertMessage = "Incorrect email"
                        }else if !signInVM.isValidPassword(_password: signInVM.password){
                            showAlert = true
                            alertMessage = "Incorrect password format"
                        }else{
                            
                            isLoading = true
                            //call the signin api
                            signInVM.signIn { success, message in
                                isLoading = false
                                if success{
                                    print("Signed in successfully")
                                    DispatchQueue.main.async {
                                        signInVM.isSignedIn = true
                                    }
                                }else{
                                    ///checks if the user account is not confirmed. If not confirmed then resends the
                                    ///confirmation code.
                                    guard let message = message else {
                                                alertMessage = "An unknown error occurred. Try again"
                                                showAlert = true
                                                return
                                            }
                    
                                    switch message {
                                    case "Account not confirmed":
                                        isLoading = true
                                        signInVM.resendConfirmationCode { success, resendMessage in
                                            isLoading = false
                                            if success {
                                                isConfirmed = true
                                            } else {
                                                alertMessage = resendMessage ?? "Error confirming account"
                                                showAlert = true
                                            }
                                        }
                                        
                                    case "Invalid credentials":
                                        alertMessage = "Invalid email or password. \n Please try again."
                                        showAlert = true
                                    
                                    case "User not found":
                                        alertMessage = "User doesnot exists. \n Please create a account first."
                                        showAlert = true
                                        
                                    default:
                                        alertMessage = message
                                        showAlert = true
                                    }
                                }
                            }
                        }
                    }
                    .alert("", isPresented: $showAlert){
                        Button("OK", role: .cancel){}
                    } message: {
                        Text(alertMessage)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom,10)
                }
                
                Spacer()
                
                HStack{
                    Text("Don't have an account?")
                        .foregroundColor(.white)
                        .font(.customfont(.semibold, fontSize: 20))
                    
                    NavigationLink(destination: GetStartedView()) {
                        Text("Sign Up")
                            .font(.customfont(.semibold, fontSize: 20))
                            .foregroundColor(Color.blue)
                    }
                }
                .padding(.bottom,50)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .ignoresSafeArea()
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            
            
            //Shows Progress view until we get response from backend after sending the request
            if isLoading {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
        }
        .navigationDestination(isPresented: $signInVM.isSignedIn) {
            MainView()
        }
        .navigationDestination(isPresented: $isConfirmed) {
            ConfirmAccountView(email: signInVM.email, password: signInVM.password)
        }
    }
}

#Preview {
    
        
    NavigationStack{
        SignInView()
    }
}
