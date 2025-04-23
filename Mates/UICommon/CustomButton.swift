//
//  CustomButton.swift
//  Groceries List
//
//  Created by Anurag Shrestha on 2/21/25.
//

import SwiftUI

struct CustomButton: View {
    @State var title: String = "Title"
    @State var color: Color = .white
    var didTap: (() -> Void)?

    var body: some View {
        Button (action: {
            didTap?()
        }) {
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .fill(.blue)
                Text(title)
                    .font(.customfont(.semibold, fontSize: 22))
                    .foregroundColor(.white)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
        }
    }
}

#Preview {
    CustomButton()
        .padding(20)
}
