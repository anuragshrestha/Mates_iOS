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

    var body: some View {
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
                
                
                CustomButton(title: "Sign In", color: .white) {
                    print("Pressed sign in")
                    if signInVM.email.isEmpty {
                       showAlert = true
                       alertMessage = "Please enter your email"
                    }else if signInVM.password.isEmpty {
                        showAlert = true
                        alertMessage = "Please enter your password"
                    }else{
                        //call the signin api
                    }
                }
                .alert("Missing Information", isPresented: $showAlert){
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
    }
}

#Preview {
    
    NavigationView{
        SignInView()
    }
}
