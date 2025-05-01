//
//  ChatView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        ZStack{
            
            Color.black.ignoresSafeArea()
            
            VStack{
                Text("Chat View")
                    .font(.customfont(.bold, fontSize: 22))
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    ChatView()
}
