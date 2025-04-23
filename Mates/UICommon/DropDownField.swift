//
//  DropDownField.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/19/25.
//


import SwiftUI


struct DropdownField: View {
    var title: String
    var value: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(value.isEmpty ? title : value)
                    .foregroundColor(value.isEmpty ? .gray : .white)
                    .font(.customfont(.semibold, fontSize: 18))
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
            
        }
        .padding(.vertical, 15)
    }
}
