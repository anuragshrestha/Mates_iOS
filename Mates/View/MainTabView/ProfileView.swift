//
//  ProfileView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var signOutVM = SignOutViewModel()
    @AppStorage("isSignedIn") var isSignedIn:Bool = false
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State private var isLoading:Bool = false
    
    var body: some View {
        
        ZStack{
            
            Color.black.ignoresSafeArea()
        
            VStack(alignment: .center){
                
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .cornerRadius(50)
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(Color.gray.opacity(0.6))
                    )
                    .clipShape(Circle())
            }
            .padding(.bottom)
            
            
          
            
            VStack{
            
                CustomButton(title: "Log Out", color: .red) {
                    print("pressed log out button")
                    isLoading = true
                    signOutVM.signOut { success, message in
                        isLoading = false
                        if success{
                            print("successfully logout.")
                        }else{
                            alertMessage = "Failed to Sign Out. \n Please try again later."
                            showAlert = true
                            print(message ?? "failed to log out")
                        }
                    }
                }
                .alert("Error", isPresented: $showAlert){
                    Button("Ok", role: .cancel){}
                } message: {
                    Text(alertMessage)
                }
                .padding(.horizontal, 120)
                .padding(.bottom, 40)
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
    ProfileView()
}
