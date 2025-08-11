//
//  AroundYouScreen.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/17/25.
//

import SwiftUI

struct AroundYouScreen: View {
    
    @ObservedObject var aroundVM: AroundYouServiceViewModel
    
    
    var body: some View {
      
        VStack(spacing: 0) {
            if aroundVM.visiblePosts.isEmpty {
                Text("No posts loaded")
                        .foregroundColor(.white)
            }else{
                ForEach(aroundVM.visiblePosts.indices, id: \.self) { index in
                    let post = aroundVM.visiblePosts[index]
                    PostScreen(post: .constant(post))
                        .padding(.bottom, 20)
                        .onAppear {
                            
                            // Load more posts when user reaches near the end
                              if aroundVM.shouldLoadMorePosts(currentIndex: index) {
                                  Task {
                                      await aroundVM.loadMorePosts()
                                  }
                              }
                        }
                        .onDisappear {
                            aroundVM.markPostSeen(post)
                        }
                }
                
                // Loading indicator for pagination
                  if aroundVM.isLoadingMore {
                      ProgressView()
                          .progressViewStyle(CircularProgressViewStyle(tint: .white))
                          .scaleEffect(1.5)
                          .padding()
                  }
                  
                  // End of posts indicator
                  if !aroundVM.hasMorePosts && !aroundVM.visiblePosts.isEmpty {
                      Text("No more posts available")
                          .foregroundColor(.gray)
                          .font(.system(size: 18))
                          .padding()
                         
                  }
            }
        }
        .onAppear {
            print("AroundYouScreen showing \(aroundVM.visiblePosts.count) posts (filtered)")
        }
    }
}


#Preview {
    
    struct PreviewWrapper: View{
        @State var samplePost = [ PostModel(
            id: UUID(),
            email: "Ethan Harper",
            mediaUrls: nil,
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
            AroundYouScreen(aroundVM: AroundYouServiceViewModel())
        }
    }
    
  
    return PreviewWrapper()
  
}
