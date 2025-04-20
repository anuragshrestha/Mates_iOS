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
                    Button {
                        print("pressed forgot password")
                    } label: {
                        Text("Forgot Password?")
                            .font(.customfont(.regular, fontSize:18))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 8)
                .padding(.trailing, 20)
                .padding(.bottom, 20)
                
                
                CustomButton(title: "Sign In", color: .white) {
                    print("Pressed sign in")
                }
                .padding(.horizontal, 20)
                .padding(.bottom,10)
            }
                
            Spacer()
                 
            HStack{
                Text("Already have an account?")
                    .foregroundColor(.white)
                    .font(.customfont(.semibold, fontSize: 20))
                
                NavigationLink(destination: SignUpView()) {
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
