import SwiftUI

struct PostDetailView: View {
    
    
    @Binding var userPost: UserPostModel
    @State var scale: CGFloat = 1
    
    
var body: some View {
       
       
        ScrollView{
        
            VStack(alignment: .leading, spacing: 4){
                
                //stack that shows the user image, name, post created time, status and image if any
                VStack(alignment: .leading, spacing: 10) {
                    
                    //profile row
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            
                            Text(userPost.fullName)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            
                            Text(timeAgo(from: userPost.createdAt))
                                .foregroundColor(.white.opacity(0.8))
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal, 10)
                    
                    Text(userPost.status)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .padding(.horizontal, 10)
                        .padding(.bottom, 5)
                    
                  
                        if let urlString = userPost.imageUrl,
                           !urlString.isEmpty,
                           let url = URL(string: urlString){
                            AsyncImage(url: url) { image in
                                image.image?.resizable()
                                    .scaledToFill()
                                    .scaleEffect(scale)
                                    .gesture(MagnificationGesture().onChanged{ value in
                                        scale = value
                                    })
                                
                            }
                            .frame(height: UIScreen.main.bounds.height * 0.5)
                            .clipped()
                            
                        }
                    
                    
        
                }
                .padding(.top, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.black)
                
                Divider()
                    .frame(width: .infinity, height: 1)
                    .background(Color.darkGray)
                    .padding(.bottom, 2)
                
                HStack(spacing: 24){
                    
                    //like button and count
                    HStack(spacing: 4) {
                        
                        Button {
                            print("pressed like button")
                        } label: {
                            
                            Image(systemName: userPost.hasLiked ? "heart.fill" : "heart")
                                .foregroundColor(userPost.hasLiked ? .red : .white)
                        }
                        
                        Text("\(userPost.likes)")
                            .foregroundColor(.white)
                    }
                    
                    HStack(spacing: 4){
                        
                        Button {
                            print("pressed comment button")
                        } label: {
                            Image(systemName: "message")
                                .foregroundColor(.white)
                        }
                        
                        Text("\(userPost.comments)")
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
        .background(Color.black.ignoresSafeArea())
        .navigationTitle("Posts")
        .navigationBarTitleDisplayMode(.inline)
}
}




struct PostDetailView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var samplePost = UserPostModel(
            id: UUID(),
            imageUrl: "",
            createdAt: "2025-06-17T12:00:00Z",
            status: "Hi guys",
            fullName: "Anurag Shrestha",
            profileImageUrl: "",
            likes: 23,
            comments: 12,
            hasLiked: true
        )

        var body: some View {
            PostDetailView(userPost: $samplePost)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
