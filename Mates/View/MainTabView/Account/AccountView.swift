//
//  AccountView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//

import SwiftUI

struct AccountView: View {
    
    
    @StateObject var signOutVM = SignOutViewModel()
    @AppStorage("isSignedIn") var isSignedIn:Bool = false
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State private var isLoading:Bool = false
    
    
    @State private var userPosts: [UserPostModel] = [
 
        UserPostModel(id: UUID(), imageUrl: "", createdAt: "2025-06-17T12:00:00Z", status: "2025-06-17T12:00:00Z" ,fullName:  "Anurag Shrestha", profileImageUrl: "", likes: 22, comments: 5, hasLiked: true),
        UserPostModel(id: UUID(), imageUrl: "", createdAt: "2025-06-17T12:00:00Z", status: "2025-06-17T12:00:00Z" ,fullName:  "Anurag Shrestha", profileImageUrl: "", likes: 22, comments: 5, hasLiked: false),
        UserPostModel(id: UUID(), imageUrl: "", createdAt: "2025-06-17T12:00:00Z", status: "2025-06-17T12:00:00Z" ,fullName:  "Anurag Shrestha", profileImageUrl: "", likes: 22, comments: 5, hasLiked: true)
    ]
    
    var body: some View {
        
        ZStack(alignment: .leading){
            
            Color.black.opacity(0.95).ignoresSafeArea()
            
            ScrollView{
                VStack(alignment: .leading){
                    
                    HStack(alignment: .top) {
                        Text("AnuragShrestha")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button {
                            print("pressed setting icon")
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    
                    //stack to show user image, counts for posts, followers and following
                    HStack{
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(maxWidth: 50, maxHeight: 50)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        //shows posts count
                        VStack(spacing: 4){
                            Text("120")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("POSTS")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        //shows followers count
                        VStack(spacing: 4) {
                            Text("520")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("FOLLOWERS")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        //shows following count
                        VStack(spacing: 4){
                            Text("420")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("FOLLOWING")
                                .font(.system(size: 14,weight: .regular))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    
                    
                    
                    VStack(alignment: .leading, spacing: 2){
                        //user name
                        Text("Anurag Shrestha")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        
                        //user university name
                        Text("Senior @ Harvard University")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        
                        //user major
                        Text("Computer Science")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        
                        //user Bio: Optional
                        Text("Building the future | Co-founder @ Twitter  Books, Hiking. ")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .medium))
                        
                        
                    }
                    .padding(.horizontal)
                    
                    
                  Divider()
                        .frame(width: .infinity, height: 1)
                        .background(Color.gray)
                        .padding(.vertical, 5)
                    
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 2){
                        
                        ForEach(userPosts.indices, id: \.self) { index in
                            NavigationLink(destination: PostDetailView(userPost: $userPosts[index])) {
                             
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: UIScreen.main.bounds.width / 3 - 4, height: UIScreen.main.bounds.width / 3 - 4)
                                    .clipped()
                                    .foregroundColor(.white)
                                    .background(Color.gray.opacity(0.3))
                            }
                            
                        }
                    }
                    .padding(.horizontal, 2)
                    .padding(.bottom, 20)
                    
                }
            }
        }
    }
}

#Preview {
   
    NavigationStack{
        AccountView()
    }
     
    
}
