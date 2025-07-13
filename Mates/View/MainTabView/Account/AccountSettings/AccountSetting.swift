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
    @Environment(\.dismiss) private var dismiss
    @StateObject var signOutVM = SignOutViewModel()
    @AppStorage("isSignedIn") var isSignedIn:Bool = false
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State private var isLoading:Bool = false
    @State private var path = NavigationPath()
    @StateObject var forgotPasswordVM = ForgotPasswordViewModel()
    
    var user : UserAccountModel?
    
    @State var user1 = UserAccountModel(
        id: UUID(),
        email: "",
        fullName: "",
        universityName: "",
        major: "",
        schoolYear: "",
        createdAt: "",
        profileImageUrl: "",
        postCount: 5,
        followersCount: 100,
        followingCount: 80
    )
    
    
    enum SettingsRoute: Hashable{
        case forgotPassword
        case changePassword
        case editProfile
    }
    
    var body: some View {
        
        NavigationStack(path: $path){
            
            ZStack(alignment: .leading){
                
                Color.black.background().ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    //shows account settings
                    HStack(spacing: 8) {
                        
                        Button(action:{
                            
                            //clears all the data if exits
                            forgotPasswordVM.confirmationCode = ""
                            forgotPasswordVM.newPassword = ""
                            forgotPasswordVM.confirmNewPassword = ""
                            forgotPasswordVM.isConfirmedForgotPassword = false
                            
                            forgotPasswordVM.email = user?.email ?? ""
                            isLoading = true
                            forgotPasswordVM.forgotPassword { success, message in
                                isLoading = false
                                
                                if success{
                                    forgotPasswordVM.email = user?.email ?? ""
                                    path.append(SettingsRoute.forgotPassword)
                                }else{
                                    showAlert = true
                                    alertMessage = "Failed to send code"
                                }
                            }
                           
                        }){
                            Image(systemName: "lock.rotation")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.gray)
                                .frame(width: 30, alignment: .leading)
                            
                            
                            
                            Text("Forgot Password")
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
                    
                    
                    
                    //changes the password
                    HStack(spacing: 8) {
                        
                        Button(action:{
                            path.append(SettingsRoute.changePassword)
                        }){
                            Image(systemName: "lock.shield.fill")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.gray)
                                .frame(width: 30, alignment: .leading)
                            
                            
                            
                            Text("Change Password")
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
                            path.append(SettingsRoute.editProfile)
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
                                   // KeychainHelper.deleteAccessToken()
                                    // isSignedIn = false
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
                
                
                //Shows Progress view until we get response from backend after sending the request
                if isLoading {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2)
                }
                
            }
            .navigationTitle("Settings and activity")
            .navigationBarBackButtonHidden(false)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    EmptyView()
                }
            }
            .navigationDestination(for: SettingsRoute.self) { route in
                switch route {
                case .forgotPassword:
                    ForgotPassword(forgotVM: forgotPasswordVM)
                case .changePassword:
                    ChangePasswordView()
                case .editProfile:
                    EditProfileView(user: $user1)
                }
            }
        }
    }
}

#Preview {
    
    NavigationStack{
        AccountSetting(user: nil)
    }
   
}
