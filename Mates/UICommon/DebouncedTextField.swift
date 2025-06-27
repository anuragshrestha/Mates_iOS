//
//  DebouncedTextField.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/26/25.
//

import SwiftUI

struct DebouncedTextField: View {
    
    let placeholder:String
    @Binding var text:String
    @State private var debounceTask: DispatchWorkItem?
    var debounceDelay: TimeInterval = 0.5
    var onDebounceChange: (String) -> Void
    @FocusState.Binding var isFocused: Bool
    
    
    var body: some View {
        
        ZStack(alignment: .leading){
            
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 5)
                    .font(.system(size: 18))
                    .fontWeight(.regular)
            }
            
            TextField("", text: $text)
                .autocorrectionDisabled(true)
                .focused($isFocused)
                .onChange(of: text) { newValue in
                    debounceTask?.cancel()
                    
                    let task = DispatchWorkItem{
                        onDebounceChange(newValue)
                    }
                    debounceTask = task
                    DispatchQueue.main.asyncAfter(deadline: .now() + debounceDelay, execute: task)
                }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var text = ""
        @FocusState private var isFocused: Bool

        var body: some View {
            DebouncedTextField(
                placeholder: "Search...",
                text: $text,
                onDebounceChange: { _ in },
                isFocused: $isFocused
            )
            .onAppear {
                isFocused = true
            }
        }
    }

    return PreviewWrapper()
}
