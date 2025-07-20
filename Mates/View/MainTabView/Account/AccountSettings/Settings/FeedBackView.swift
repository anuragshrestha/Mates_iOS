//
//  FeedBack View.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/18/25.
//

import SwiftUI

struct FeedBackView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var message: String = ""
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State var isLoading:Bool = false
    
    
    var body: some View {
     
        ZStack{
            Color.black.ignoresSafeArea()
            
            VStack{
                
                //custom post field
                PostField(text: $message, placeholder: "Any feedback you want to share?")
                    .padding(.bottom, 20)
                    .padding(.top, UIScreen.main.bounds.height * 0.1)
                    
                //submit button
                Button(action: {
                    if message.isEmpty{
                        alertMessage = "Please enter your feedback first"
                        showAlert = true
                    } else{
                        let request = FeedBackRequest(message: message)
                        //call the send api
                        isLoading = true
                        AccountService.sendFeedBack(request: request) { success, mes in
                            isLoading = false
                            DispatchQueue.main.async {
                                if success{
                                    alertMessage = "Successfully sent the feedback"
                                    showAlert = true
                                    message = ""
                                }else{
                                    alertMessage = mes ?? "Failed to sent feedback"
                                    showAlert = true
                                }
                            }
                        }
                    }
                }) {
                    Text("Submit")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .semibold))
                        .padding(.horizontal, 12)
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
            
            if isLoading{
                
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
                }){
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Send feedback")
                    .foregroundColor(.white)
                    .font(.system(size: 22, weight: .semibold))
            }
        }
    }
}

#Preview {
    FeedBackView()
}
