
/**
 * This view shows the posts details of the current user who is logged in
 */


import SwiftUI

struct PostDetailView: View {
    
    
    @Binding var post: UserPostModel
    let user: UserAccountModel
    @State var scale: CGFloat = 1
    
    
var body: some View {
       
       
        ZStack{
                    
            VStack(alignment: .leading, spacing: 4){
                
                //stack that shows the user image, name, post created time, status and image if any
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack(alignment: .top, spacing: 12) {
                        
                        //profile image
                        AsyncImage(url: URL(string: user.profileImageUrl)) { image in
                            image.image?.resizable()
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())

                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullName)
                                .font(.customfont(.bold, fontSize: 18))
                                .foregroundColor(.white)
                            
                            Text(timeAgo(from: post.createdAt))
                                .foregroundColor(.white.opacity(0.6))
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)
                    
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
                .padding(.top, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
   
                
                Divider()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .background(Color.darkGray)
                    .padding(.bottom, 2)
                
                HStack(spacing: 24){
                    
                    //like button and count
                    HStack(spacing: 4) {
                        Button(action: {
                            Task{
                                
                                //checks if the post is liked
                                if post.hasLiked {
                                    post.hasLiked = false
                                    if post.likes > 0 {
                                        post.likes = post.likes - 1
                                    }
                                      //api call to unlike the post
                                    LikeUnlikeService.shared.unlikePost(request: likeUnlikeRequest(post_id: post.id)) { success, message in
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
                                    LikeUnlikeService.shared.likePost(request: likeUnlikeRequest(post_id: post.id)) { success, message in
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
                            .foregroundColor(.white)
                    }
                    
                    
                    HStack(spacing: 4){
                        
                        Button {
                            print("pressed comment button")
                        } label: {
                            Image(systemName: "message")
                                .foregroundColor(.white)
                        }
                        
                        Text("\(post.comments)")
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 4) {
                        Button{
                            
                        }label: {
                            Image(systemName: "paperplane")
                                .foregroundColor(.white)
                        }
                        
                        Text("2")
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 10)
                
            }
            .padding(.top)
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
}
}




struct PostDetailView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var samplePost = UserPostModel(
            id: "1251625176",
            mediaUrls: nil,
            createdAt: "2025-06-17T12:00:00Z",
            status: "Hi guys",
            likes: 23,
            comments: 12,
            hasLiked: true
        )
        
        let sampleUser = UserAccountModel(
            id: UUID(),
            email: "test@example.com",
            fullName: "Anurag Shrestha",
            universityName: "Harvard University",
            major: "Computer Science",
            schoolYear: "Senior",
            createdAt: "2024-01-01T00:00:00Z",
            profileImageUrl: "https://example.com/profile.jpg",
            postCount: 5,
            followersCount: 100,
            followingCount: 80,
            bio: "Hi guys"
        )

        var body: some View {
            PostDetailView(post: $samplePost, user: sampleUser)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
