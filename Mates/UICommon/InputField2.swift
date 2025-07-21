//
//  InputField2.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/19/25.
//

import SwiftUI

/// A reusable Input text field to enter the email address, name and data like that.
/// - Parameters:
///   - email: A binding to the user's input text.
///   - placeholder: The placeholder text to show.

struct InputField2: View {
    @Binding var text: String
    @State var placeholder: String

    var body: some View {
        TextField("",
                  text: $text,
                  prompt: Text(placeholder)
            .foregroundColor(.white)
            .font(.customfont(.semibold, fontSize: 20))
            )
           .font(.customfont(.semibold, fontSize: 20))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: 30)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
            .overlay(RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black, lineWidth: 2))
          
    }
}



#Preview {
    struct PreviewWrapper: View {
        @State var text: String = ""

        var body: some View {
            InputField2(text: $text, placeholder: "Enter your school email")
                .padding()
        }
    }
    return PreviewWrapper()
}

