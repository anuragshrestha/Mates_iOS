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
    
    
    var body: some View {
        
        ZStack(alignment: .leading){
            
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 5)
            }
            
            TextField("", text: $text)
                .autocorrectionDisabled(true)
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
    DebouncedTextField( placeholder: "Search...",
                        text: .constant(""),
                        onDebounceChange: { _ in })
}
