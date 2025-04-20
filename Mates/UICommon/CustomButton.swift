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
        Button {
            didTap?()
        } label: {
            Text(title)
                .font(.customfont(.semibold, fontSize: 22))
                .foregroundColor(color)
                .multilineTextAlignment(.center)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
        .background(.blue)
        .cornerRadius(20)
    }
}

#Preview {
    CustomButton()
        .padding(20)
}
