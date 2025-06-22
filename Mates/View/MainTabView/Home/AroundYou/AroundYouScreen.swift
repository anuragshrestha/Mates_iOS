//
//  AroundYouScreen.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/17/25.
//

import SwiftUI

struct AroundYouScreen: View {
    
    @Binding var posts: [PostModel]
    
    
    var body: some View {
      
        VStack(spacing: 0) {
            if posts.isEmpty {
                Text("No posts loaded")
                        .foregroundColor(.white)
            }else{
                
                ForEach(posts.indices, id: \.self) { index in
                    PostScreen(post: $posts[index])
                        .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            print("AroundYouScreen received \(posts.count) posts")
        }
    }
}


#Preview {
    
    struct PreviewWrapper: View{
        @State var samplePost = [ PostModel(
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
            comments: 12,
            hasLiked: true
        )
        ]
        
        var body: some View{
            AroundYouScreen(posts: $samplePost)
        }
    }
    
  
    return PreviewWrapper()
  
}
