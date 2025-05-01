//
//  PostView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//

import SwiftUI

struct PostView: View {
    var body: some View {
        ZStack{
            
            Color.black.ignoresSafeArea()
            
            VStack{
                Text("Post View")
                    .font(.customfont(.bold, fontSize: 22))
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    PostView()
}
