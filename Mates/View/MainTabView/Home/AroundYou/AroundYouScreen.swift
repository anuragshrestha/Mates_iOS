//
//  AroundYouScreen.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/17/25.
//

import SwiftUI

struct AroundYouScreen: View {
    
    let posts: [PostModel]
    
    
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
    let samplePost = PostModel(
        id: UUID(),
        email: "Ethan Harper",
        imageUrl: "ethan@unm.edu",
        createdAt: UUID().uuidString,
        status: "https://example.com/avatar.jpg",
        userId: "https://example.com/dining-hall.jpg",
        universityName: "Anyone else feel like the dining hall food has been extra bland lately? #CollegeLife",
        fullName: "2025-06-17T12:00:00Z",
        profileImageUrl: "University of New Mexico",
        likes: 23,
        comments: 12
    )
    
    AroundYouScreen(posts: [samplePost])
}
