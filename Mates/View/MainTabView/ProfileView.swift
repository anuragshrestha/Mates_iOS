//
//  ProfileView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack{
            
            Color.black.ignoresSafeArea()
            
            VStack{
                Text("Profile View")
                    .font(.customfont(.bold, fontSize: 22))
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    ProfileView()
}
