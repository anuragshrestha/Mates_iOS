//
//  TabButton.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//



import SwiftUI

struct TabButton: View {
    @State var title: String = "title"
    @State var filledIcon: String
    @State var unFilledIcon: String
    var isSelect: Bool = false
    var didSelect: () -> Void

    var body: some View {
        Button {
            didSelect()
        } label: {
            VStack {
                Image(systemName: isSelect ? filledIcon : unFilledIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)

                Text(title)
                    .font(.customfont(.semibold, fontSize: 20))
            }
        }
        .foregroundColor(.white)
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

#Preview {
    TabButton(title: "Home", filledIcon: "house.fill", unFilledIcon: "house", isSelect: true) {
        print("select")
    }
}
