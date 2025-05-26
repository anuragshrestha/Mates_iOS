//
//  PostField.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/26/25.
//

import SwiftUI

struct PostField: View {
    @Binding var text: String
    var placeholder: String
    
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
                  
                  RoundedRectangle(cornerRadius: 12)
                .fill(Color.darkGray.opacity(0.8))
             
                  // Multiline text input
                  TextEditor(text: $text)
                     .focused($isFocused)
                     .foregroundColor(.white)
                     .font(.customfont(.semibold, fontSize: 20))
                     .frame(height: 160)
                     .padding(.horizontal, 10)
                     .padding(.vertical, 12)
                     .background(Color.clear)
                     .disableAutocorrection(true)
                     .textInputAutocapitalization(.never)
                     .scrollContentBackground(.hidden)
                  
                  // Placeholder if text is empty and not focused on the TextEditor
                  if text.isEmpty && !isFocused {
                      Text(placeholder)
                          .foregroundColor(.white)
                          .font(.customfont(.semibold, fontSize: 20))
                          .padding(.top, 18)
                          .padding(.horizontal, 16)
                          .allowsHitTesting(false)
                  }
          }
          .frame(height: 160)
          .padding(.horizontal, 6)
    
 
       
    }
}


#Preview {
    PreviewWrapper()
}

struct PreviewWrapper: View {
    @State private var text: String = ""
    
    var body: some View {
        PostField(text: $text, placeholder: "What's on your mind?")
    }
}
