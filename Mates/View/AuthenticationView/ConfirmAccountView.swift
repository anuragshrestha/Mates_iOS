//
//  ConfirmAccountView.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/17/25.
//



import SwiftUI

struct ConfirmAccountView: View {
    
    
    @StateObject var confirmVM = ConfirmAccountViewModel()
    @State var showAlert: Bool = false
    @State var alertMessage:String = ""
    @State private var isLoading:Bool = false

    var email: String
    var password:String
    
    
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
                        confirmVM.confirmAccount{ success, message in
                       
                            if success{
                                let signInRequest = SignInRequest(username: email, password: confirmVM.tempPassword)
                                
                                Task {
                                    do {
                                        let response = try await SignInService.shared.signInService(data: signInRequest)
                                            isLoading = false
                                        if response.success, let accessToken = response.accessToken {
                                            KeychainHelper.saveAccessToken(accessToken)
                                            confirmVM.isConfirmed = true
                                        }else{
                                            alertMessage = response.message ?? "Your account is now confirmed, but we couldn’t sign you in. Please sign in manually."
                                            showAlert = true
                                        }
                                    }catch{
                                        isLoading = false
                                        alertMessage = error.localizedDescription
                                        showAlert = true
                                    }
                                }
                            } else{
                                isLoading = false
                                showAlert = true
                                alertMessage = message ?? "Error occurred. \n Please signin again."
                            }
                        }
                        
                    }
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
                confirmVM.tempPassword = password
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $confirmVM.isConfirmed) {
                MainView()
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
