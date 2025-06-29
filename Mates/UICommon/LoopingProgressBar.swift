//
//  LoopingProgressBar.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/28/25.
//

import SwiftUI

struct LoopingProgressBar: View {
    @State private var progress: Double = 0.0
    let duration: TimeInterval = 2.0
    
    var body: some View {
        ProgressView(value: progress)
            .progressViewStyle(LinearProgressViewStyle(tint: .white.opacity(0.8)))
            .scaleEffect(x: 1, y: 6, anchor: .center)
            .padding(.horizontal)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { _ in
                    progress = 0
                    withAnimation(.linear(duration: duration)) {
                        progress = 1.0
                    }
                }
            }
    }
}


#Preview {
    LoopingProgressBar()
}
