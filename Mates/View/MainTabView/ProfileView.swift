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
    
    var body: some View {
        ZStack{
            
            Color.black.ignoresSafeArea()
            
            VStack{
                Text("Profile View")
                    .font(.customfont(.bold, fontSize: 22))
                    .foregroundColor(.white)
                    .padding(.top, 100)
                
                Spacer()
                
                
                CustomButton(title: "Log Out", color: .red) {
                    print("pressed log out button")
                    signOutVM.signOut { success, message in
                        if success{
                            print("successfully logout.")
                         
                        }
                    }
                }
                .padding(.horizontal, 120)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    ProfileView()
}
