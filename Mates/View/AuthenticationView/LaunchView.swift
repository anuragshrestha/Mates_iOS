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
    
    
    var body: some View {
        Group {
            if isReady {
                if isSignedIn && KeychainHelper.loadAccessToken() != nil {
                    MainView()
                }else{
                    SignInView()
                }
            } else {
                VStack {
                    Image("AppIcon1")
                        .resizable()
                        .frame(width: 120, height: 120)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isReady = true
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        LaunchView()
    }
}
