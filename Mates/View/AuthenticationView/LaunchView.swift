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
    
    
    //checks if the token is experied and not revoked
    private func handleLaunchTokenCheck() {
        DispatchQueue.global(qos: .userInitiated).async {
            //var signedIn = false
            
            guard let token = KeychainHelper.loadAccessToken(), !JWTHelper.isTokenExpired(token) else {
                print("Token is nil or expired")
                KeychainHelper.deleteAccessToken()
                DispatchQueue.main.async {
                    isSignedIn = false
                    isReady = true
                }
                return
            }
            
            // Validate with backend
            var request = URLRequest(url: URL(string: "\((Config.baseURL))/auth/validate")!)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                        isSignedIn = true
                    } else {
                        print("Access token revoked or invalid. Logging out.")
                        KeychainHelper.deleteAccessToken()
                        isSignedIn = false
                    }
                    isReady = true
                }
            }.resume()
        }
    }
    
}

#Preview {

    LaunchView()
}
