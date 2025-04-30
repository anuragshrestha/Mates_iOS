//
//  SecureTextField.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/17/25.
//

import SwiftUI

/// A reusable SwiftUI component that provides a stylized input field
/// capable of toggling between secure (password) and plain text input modes.
///
/// - Parameters:
///   - email: A binding to the input text value entered by the user.
///   - placeholder: A static placeholder string displayed in the text field.
///   - isSecure: A binding boolean flag that controls whether the input is secure (obscured) or visible.
///
/// This view conditionally renders either a `SecureField` or a `TextField`
/// based on the `isSecure` flag. It supports visual styling, disables auto-correction,
/// applies word-level autocapitalization, and includes a custom show/hide modifier (e.g. eye button).
///

struct SecureTextField: View {
    @Binding var password: String
    @State var placeholder: String
    @Binding var isSecure: Bool

    var body: some View {
        Group {
            if isSecure {
                TextField("",
                          text: $password,
                          prompt: Text(placeholder)
                    .foregroundColor(Color.black.opacity(0.8))
                              .font(.customfont(.semibold, fontSize: 20)))
            } else {
                SecureField("",
                            text: $password,
                            prompt: Text(placeholder)
                                .foregroundColor(.black)
                                .font(.customfont(.semibold, fontSize: 20)))
            }
        }
        .foregroundColor(.black)
        .font(.customfont(.semibold, fontSize: 20))
        .multilineTextAlignment(.center)
        .frame(height: 30)
        .disableAutocorrection(true)
        .textInputAutocapitalization(.never)
        .modifier(ShowButton(isShow: $isSecure))
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
        @State var password: String = ""
        @State var isSecure: Bool = false

        var body: some View {
            SecureTextField(password: $password, placeholder: "Enter your password", isSecure: $isSecure)
                .padding(.horizontal, 20)
        }
    }

    return PreviewWrapper()
}
