//
//  HelpSupportField.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/18/25.
//

import SwiftUI

struct HelpSupportField: View {


        @Binding var text: String
        var placeholder: String
        
        @FocusState private var isFocused: Bool

        var body: some View {
            ZStack(alignment: .topLeading) {
                      
                      RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.8))
                 
                      // Multiline text input
                      TextEditor(text: $text)
                         .focused($isFocused)
                         .foregroundColor(.black.opacity(0.8))
                         .font(.customfont(.semibold, fontSize: 20))
                         .frame(height: 130)
                         .padding(.horizontal, 10)
                         .padding(.vertical, 12)
                         .disableAutocorrection(true)
                         .textInputAutocapitalization(.never)
                         .scrollContentBackground(.hidden)
                         .background(RoundedRectangle(cornerRadius: 12)
                             .fill(Color.white))
                         .overlay(RoundedRectangle(cornerRadius: 12)
                             .stroke(Color.white, lineWidth: 2))
                        
                      
                      // Placeholder if text is empty and not focused on the TextEditor
                      if text.isEmpty && !isFocused {
                          Text(placeholder)
                              .foregroundColor(.black.opacity(0.8))
                              .font(.customfont(.semibold, fontSize: 20))
                              .padding(.top, 18)
                              .padding(.horizontal, 16)
                              .allowsHitTesting(false)
                      }
              }
              .frame(height: 130)
              .padding(.horizontal, 6)
        
     
           
        }
    }






#Preview {
    HelpSupportField_Preview()
}

struct HelpSupportField_Preview: View {
    @State private var text: String = ""
    
    var body: some View {
        HelpSupportField(text: $text, placeholder: "What's on your mind?")
    }
}
