//
//  VideoPlayerView.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/6/25.
//

import SwiftUI
import AVKit


struct VideoPlayerView: View {
    
    @State private var player: AVPlayer
    @State private var isPlaying: Bool = true
    
    let width: CGFloat
    let height: CGFloat
    
    init(url: URL, width: CGFloat, height: CGFloat){
        _player = State(initialValue:  AVPlayer(url: url))
        self.width = width
        self.height = height
        
    }
    
    var body: some View {
        ZStack {
            
            VideoPlayer(player: player)
                .frame(width: width, height: height)
                .cornerRadius(10)
                .onAppear {
                    player.play()
                }
                .onDisappear{
                    player.pause()
                }
        }

    }
}


