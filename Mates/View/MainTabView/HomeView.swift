//
//  HomeView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
       
        ZStack{
            
            Color.black.ignoresSafeArea()
            
            VStack{
                Text("Home View")
                    .font(.customfont(.bold, fontSize: 22))
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    HomeView()
}
