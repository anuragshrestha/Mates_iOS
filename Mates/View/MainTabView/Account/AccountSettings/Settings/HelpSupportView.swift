//
//  HelpSupport View.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/18/25.
//

import SwiftUI

struct HelpSupportView: View {
    
    @Environment(\.dismiss) var dismiss
    
  
    @State var email:String = ""
    @State var message: String = ""
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State var isLoading:Bool = false
    
    
    var body: some View {
    
        ZStack{
            
            Color.black.ignoresSafeArea()
            
            
            VStack{
                
            InputField(text: $email, placeholder: "Best email to reach back to you")
                    .padding(.bottom, 20)
                    .padding(.top, UIScreen.main.bounds.height * 0.1)
              
            HelpSupportField(text: $message, placeholder: "How can we help you?")
                    .padding(.bottom, 20)
                
                Button(action: {
                    
                     if email.isEmpty{
                        alertMessage = "Please enter your email"
                        showAlert = true
                    } else if !checkEmail(_email: email){
                        alertMessage = "Email must be .edu school email"
                        showAlert = true
                    } else if message.isEmpty {
                        alertMessage = "Enter the help and support you need"
                        showAlert = true
                    } else {
                        isLoading = true
                        let request = HelpSupportRequest(email: email, message: message)
                        //call api to send the help and support
                        AccountService.sendHelpSupport(request: request) { success, mes in
                            isLoading = false
                            
                            DispatchQueue.main.async {
                                if success{
                                    alertMessage = "Successfully sent the request"
                                    showAlert = true
                                    email = ""
                                    message = ""
                                }else{
                                    alertMessage = mes ?? "Failed to sent the request"
                                    showAlert = true
                                }
                            }
                        }
                    }
                }){
                    Text("Send")
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .semibold))
                        .padding(.horizontal, 38)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .alert("", isPresented: $showAlert) {
                    Button("Ok", role: .cancel){}
                } message: {
                    Text(alertMessage)
                }
                
                Spacer()
                
            }
            
            if isLoading {
                
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Help and Support")
                    .font(.system(size: 22, weight: .semibold))
            }
            
        }
    }
    
    
    //checks if the email is a valid school email
    func checkEmail(_email: String) -> Bool {
        
        let pattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.edu$"
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", pattern)
        
        return predicate.evaluate(with: email)
    }
    
}

#Preview {
    HelpSupportView()
}
