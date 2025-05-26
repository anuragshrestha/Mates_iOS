//
//  InputField.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/17/25.
//
import SwiftUI

/// A reusable Input text field to enter the email address, name and data like that.
/// - Parameters:
///   - email: A binding to the user's input text.
///   - placeholder: The placeholder text to show.

struct InputField: View {
    @Binding var text: String
    @State var placeholder: String

    var body: some View {
        TextField("",
                  text: $text,
                  prompt: Text(placeholder)
            .foregroundColor(.black.opacity(0.8))
            .font(.customfont(.semibold, fontSize: 20)))
            .foregroundColor(.black)
            .font(.customfont(.semibold, fontSize: 20))
            .multilineTextAlignment(.center)
            .frame(height: 30)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .padding()
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(Color.white))
            .overlay(RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white, lineWidth: 2))
            .padding(.horizontal, 20)
    }
}



#Preview {
    struct PreviewWrapper: View {
        @State var text: String = ""

        var body: some View {
            InputField(text: $text, placeholder: "Enter your school email")
                .padding()
        }
    }
    return PreviewWrapper()
}
