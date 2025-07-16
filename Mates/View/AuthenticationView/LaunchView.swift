//
//  LaunchView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/20/25.
//

import SwiftUI

struct LaunchView: View {
    
    
    @State private var isReady = false
    @AppStorage("isSignedIn") var isSignedIn: Bool = false
    @StateObject var userSession = UserSession()
    
    @ViewBuilder
        private var destinationView: some View {
            if isSignedIn && KeychainHelper.loadAccessToken() != nil {
                MainView()
                    .environmentObject(userSession)
            } else {
                SignInView()
            }
        }

        var body: some View {
            Group {
                if isReady {
                  
                    destinationView
                 
                } else {
                    VStack {
                        Image("AppIcon1")
                            .resizable()
                            .frame(width: 120, height: 120)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                    .onAppear {
                        handleLaunchTokenCheck()
                    }
                }
            }
        }
    
    
    private func handleLaunchTokenCheck() {
        DispatchQueue.global(qos: .userInitiated).async {
            var signedIn = false
            if let token = KeychainHelper.loadAccessToken(),
               JWTHelper.isTokenExpired(token) {
                print("Access token expired. Logging out user.")
                KeychainHelper.deleteAccessToken()
                signedIn = false
            } else if KeychainHelper.loadAccessToken() != nil {
                signedIn = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                         isSignedIn = signedIn
                         isReady = true
                     }
                }
            }
        }
    }
}

#Preview {

    LaunchView()
}
