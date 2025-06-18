//
//  AroundYouScreen.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/17/25.
//

import SwiftUI

struct AroundYouScreen: View {
    
    let posts: [Post]
    
    
    var body: some View {
      
        VStack(spacing: 0) {
            ForEach(posts) { post in
                PostScreen(post: post)
                    .padding(.bottom, 20)
            }
        }
    }
}


#Preview {
    
    let  samplePost = Post(
         name: "Ethan Harper",
         avatar: "ethan",
         time: "2d",
         text: "Anyone else feel like the dining hall food has been extra bland lately? #CollegeLife",
         imageName: nil,
         likes: 23,
         comments: 12,
         shares: 5
     )
     
      return AroundYouScreen(posts: [samplePost])
}
