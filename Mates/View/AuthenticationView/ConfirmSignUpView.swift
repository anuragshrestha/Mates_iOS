//
//  ConfirmSignUpView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/17/25.
//

import SwiftUI

struct ConfirmSignUpView: View {
    
    
    @StateObject var confirmVM = ConfirmSignUpViewModel()
    @State var showAlert: Bool = false
    @State var alertMessage:String = ""
    
    var body: some View {
        
        VStack {
            InputField(text: $confirmVM.confirmationCode, placeholder: "Enter confirmation code")
            
            
            NavigationLink(destination: MainView(), isActive: $confirmVM.isConfirmed) {
                CustomButton(title: "Confirm") {
                    print("pressed confirm button")
                    //checks if the code is correct
                    if !confirmVM.confirmationCode.isEmpty {
                        confirmVM.isConfirmed = true
                    } else{
                        showAlert = true
                        alertMessage = "Please enter a valid code"
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .ignoresSafeArea()
      
    }
    
}

#Preview {
    NavigationView{
        ConfirmSignUpView()
    }
}
