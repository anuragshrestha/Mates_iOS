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
    
    var email: String
    
    var body: some View {
        
        VStack {
            InputField(text: $confirmVM.confirmationCode, placeholder: "Enter confirmation code")
            
                CustomButton(title: "Confirm") {
    
                    //checks if the code is correct
                    if confirmVM.confirmationCode.isEmpty {
                        showAlert = true
                        alertMessage = "Please enter a valid code"
                    } else{
                        confirmVM.confirmSignUp { success, message in
                            if success{
                                confirmVM.isConfirmed = true
                            } else{
                                showAlert = true
                                alertMessage = message ?? "Error occurred"
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $confirmVM.isConfirmed) {
            MainView()
        }
    }
    
}

#Preview {
    NavigationStack{
        ConfirmView(email: "")
    }
}
