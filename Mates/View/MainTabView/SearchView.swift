//
//  SeacrhView.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/24/25.
//

import SwiftUI

struct SeacrhView: View {
    var body: some View {
        ZStack{
            
            Color.black.ignoresSafeArea()
            
            VStack{
                Text("Seacrh View")
                    .font(.customfont(.bold, fontSize: 22))
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    SeacrhView()
}
