//
//  ConfirmView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/17/25.
//

import SwiftUI

struct ConfirmView: View {
    
    
    @StateObject var confirmVM = ConfirmSignUpViewModel()
    @State var showAlert: Bool = false
    @State var alertMessage:String = ""
    @State private var isLoading:Bool = false
    @State var accountConfirmed:Bool = false
    @State var confirmedMessage:String = ""
    @State var navigateToSignIn:Bool = false
    
    var email: String
    var password: String
   
    
    
    var body: some View {
        ZStack{
            VStack {
                InputField(text: $confirmVM.confirmationCode, placeholder: "Enter confirmation code")
                
                CustomButton(title: "Confirm") {
                    
                    //checks if the code is correct
                    if confirmVM.confirmationCode.isEmpty {
                        showAlert = true
                        alertMessage = "Please enter a valid code"
                    } else{
                        isLoading = true
                        
                        confirmVM.confirmSignUp { success, message in
                         isLoading = false
                            if success{
                                let signInRequest = SignInRequest(username: email, password: confirmVM.password)
                                
                                Task {
                                    do {
                                        let response = try await SignInService.shared.signInService(data: signInRequest)
                                        isLoading = false
                                        if response.success, let accessToken = response.accessToken {
                                            KeychainHelper.saveAccessToken(accessToken)
                                            confirmVM.isConfirmed = true
                                        }else{
                                            
                                            confirmedMessage = "Successfully created account. \n Please sign in"
                                            accountConfirmed = true
                                        }
                                    }catch{
                                        isLoading = false
                                        alertMessage = error.localizedDescription
                                        showAlert = true
                                    }
                                }
                            } else{
                                showAlert = true
                                alertMessage = message ?? "Error occurred"
                            }
                        }
                        
                    }
                }
                .alert("Account created", isPresented: $accountConfirmed){
                    Button("Ok"){
                        navigateToSignIn = true
                    }
                } message: {
                    Text(confirmedMessage)
                }
                .alert("Missing Code", isPresented: $showAlert){
                    Button("Ok", role: .cancel) {}
                } message: {
                    Text(alertMessage)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
            .onAppear{
                confirmVM.email = email
                confirmVM.password = password
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $confirmVM.isConfirmed) {
                MainView()
            }
            .navigationDestination(isPresented: $navigateToSignIn) {
                SignInView()
            }
            
            //Shows Progress view until we get response from backend after sending the request
            if isLoading {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
        }
    }
    
}

#Preview {
    NavigationStack{
        ConfirmView(email: "", password: "")
    }
}
