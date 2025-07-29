//
//  PostScreen.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/24/25.
//

import SwiftUI

struct PostScreen: View {
    
    @Binding var post: PostModel
    
    var body: some View {
        
        ZStack{
            //Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 4) {
                VStack(alignment: .leading, spacing: 10){
                    
                    //Profile row
                    HStack(alignment: .top, spacing: 12) {
                        AsyncImage(url: URL(string: post.profileImageUrl)){ image in
                            image.image?.resizable()
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(post.fullName)
                                .font(.customfont(.bold, fontSize: 18))
                                .foregroundColor(.white)
                            
                            Text(timeAgo(from: post.createdAt))
                                .foregroundColor(.white.opacity(0.6))
                                .font(.subheadline)
                        }
                        
                    }
                    .padding(.horizontal, 10)
                    
                    //Post Content
                    Text(post.status)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .padding(.horizontal, 10)
                        .padding(.bottom, 5)
                        
                       
                 
        
                    
                  //shows the medias
                      if let mediaUrls = post.mediaUrls, !mediaUrls.isEmpty {
                          GeometryReader { geometry in
                              ScrollView(.horizontal, showsIndicators: false){
                                  LazyHStack(spacing: 12) {
                                      ForEach(mediaUrls.indices, id: \.self){ index in
                                          let media = mediaUrls[index]
                                            if media.type == "image",
                                               let url = URL(string: media.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                                                
                                                AsyncImage(url: url) { phase in
                                                    switch phase {
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                    case .failure:
                                                        Color.red
                                                    case .empty:
                                                        ProgressView()
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                                .frame(width: geometry.size.width, height: 300)
                                                .clipped()
                                                .cornerRadius(10)
                                                
                                            } else if media.type == "video",
                                                      let url = URL(string: media.url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                                                
                                                VideoPlayerView(url: url, width: geometry.size.width, height: 300)
                                                   
                                          }
                                          
                                      }
                                      
                                  }
                                  .padding(.horizontal, 10)
                              }
                          }
                          .frame(height: 300)
                      }

                    
                    
                    
                }
                .padding(.top,5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.black)
               
                
                
                    HStack(spacing: 24) {
                        HStack(spacing: 4) {
                            Button(action: {
                                Task{
                                    if post.hasLiked {
                                        post.hasLiked = false
                                        if post.likes > 0 {
                                            post.likes = post.likes - 1
                                        }
                                          //api call to unlike the post
                                        LikeUnlikeService.shared.unlikePost(request: likeUnlikeRequest(post_id: post.id.uuidString.lowercased())) { success, message in
                                            if success {
                                                print("successfully unliked the post")
                                            }else{
                                                print("failed to unlike the post")
                                            }
                                        }
                                    }else{
                                        post.hasLiked = true
                                        post.likes += 1
                                
                                        //api call to like the post
                                        LikeUnlikeService.shared.likePost(request: likeUnlikeRequest(post_id: post.id.uuidString.lowercased())) { success, message in
                                            if success {
                                                print("successfully liked the post")
                                            }else{
                                                print("failed to like the post")
                                            }
                                        }
                                   }
                                }
                            }){
                                Image(systemName: post.hasLiked ? "heart.fill" : "heart")
                                    .foregroundColor(post.hasLiked ? .red : .white)
                            }
    
                            Text("\(post.likes)")
                        }
                        
                        
                        HStack(spacing: 4) {
                            
                            Image(systemName: "message")
                            
                            Text("\(post.comments)")
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "paperplane")
                            
                            Text("0")
                        }
                    }
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.top, 4)
                    .padding(.horizontal, 10)
                
                Divider()
                    .frame(height: 2)
                    .background(Color.white.opacity(0.5))
                    .padding(.top, 5)
                  
                
            }
            .padding(.horizontal, 10)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
         }
        
    }
}

#Preview {
    
        struct PreviewWrapper: View {
            @State var samplePost = PostModel(
                id: UUID(),
                email: "ethan@unm.edu",
                mediaUrls: nil,
                createdAt: "2025-06-17T12:00:00Z",
                status: "Anyone else feel like the dining hall food has been extra bland lately? #CollegeLife",
                userId: "user-123",
                universityName: "University of New Mexico",
                fullName: "Ethan Harper",
                profileImageUrl: "https://example.com/profile.jpg",
                likes: 23,
                comments: 12,
                hasLiked: true
            )

            var body: some View {
                PostScreen(post: $samplePost)
            }
        }

       return  PreviewWrapper()

}
