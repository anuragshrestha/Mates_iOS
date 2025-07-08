//
//  AccountSetting.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/1/25.
//

import SwiftUI

struct AccountSetting: View {
    
    
    /**
     * Account settings: change password, delete account
     * Edit profile: option to change all the personal info including location
     * feedback
     *help & support*
     */
    
    @StateObject var signOutVM = SignOutViewModel()
    @AppStorage("isSignedIn") var isSignedIn:Bool = false
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State private var isLoading:Bool = false
    
    var user : UserAccountModel?
    
    
    var body: some View {
       
        ZStack(alignment: .leading){
            
            Color.black.background().ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 6) {
                
                //shows account settings
                HStack(spacing: 8) {
                    
                    Button(action:{
                        print("pressed")
                    }){
                        Image(systemName: "gearshape")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.gray)
                            .frame(width: 30, alignment: .leading)
                           
                           
                        
                        Text("Accounts Settings")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.leading, 5)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 10)
                
                
                //options for editing profile
                HStack(spacing: 6) {
                    
                    Button(action: {
                        
                    }){
                        Image(systemName: "pencil")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.gray)
                            .frame(width: 30, alignment: .leading)
                        
                        
                        Text("Edit Profile")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.leading, 5)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 10)
                
                
                //feedback option
                HStack(spacing: 6) {
                    
                    Button(action: {
                        
                    }){
                        Image(systemName: "envelope")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.gray)
                            .frame(width: 30, alignment: .leading)
                        
                        Text("Feedback")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.leading, 5)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 10)
                
                
                //option for help and support
                HStack(spacing: 6) {
                    
                    Button(action: {
                        
                    }){
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.gray)
                            .frame(width: 30, alignment: .leading)
                        
                        Text("Help & Support")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.leading, 5)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 10)
                
                
                Spacer()
                
                
            }
            .padding(.horizontal)
            .padding(.top, 50)
       
            VStack{
                Spacer()
                
                
                HStack(){
                    
                    Spacer()
                    
                    Button(action: {
                        print("pressed signout button")
                        isLoading = true
                        signOutVM.signOut { success, message in
                            isLoading = false
                            if success{
                                print("successfully logout.")
    //                            KeychainHelper.deleteAccessToken()
    //                            isSignedIn = false
                            }else{
                                alertMessage = "Failed to Sign Out. \n Please try again later."
                                showAlert = true
                                print(message ?? "failed to log out")
                            }
                        }
                    }) {
                        Text("Log out")
                            .font(.system(size: 26, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 10)
                            .background(Color.red)
                            .cornerRadius(14)
                           
                    }
                    .alert("Error", isPresented: $showAlert){
                        Button("Ok", role: .cancel){}
                    } message: {
                        Text(alertMessage)
                    }

                    
                    Spacer()
                }
                .padding(.bottom, 30)
              
            }
           
            
        }
        .navigationTitle("Settings and activity")
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    
    NavigationStack{
        AccountSetting(user: nil)
    }
   
}
