//
//  FeedBack View.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/18/25.
//

import SwiftUI

struct FeedBackView: View {
    
    @State var text: String = ""
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State var isLoading:Bool = false
    
    
    var body: some View {
     
        ZStack{
            Color.black.ignoresSafeArea()
            
            VStack{
                
                //custom post field
                PostField(text: $text, placeholder: "Any feedback you want to share?")
                    .padding(.bottom, 20)
                    
                //submit button
                Button(action: {
                    if text.isEmpty{
                        alertMessage = "Please enter your feedback first"
                        showAlert = true
                    } else{
                        
                        //call the send api
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
    }
}

#Preview {
    FeedBackView()
}
