//
//  PostScreen.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/24/25.
//

import SwiftUI

struct PostScreen: View {
    
    let post: PostModel
    
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
                            
                            Text(post.createdAt)
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                        
                    }
                    
                    //Post Content
                    Text(post.status)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .padding(.horizontal, 2)
                        .padding(.bottom, 5)
                        
                       
                 
        
                    if post.imageUrl != nil {
                        
                        AsyncImage(url: URL(string: post.imageUrl ?? "")) { image in
                            image.image?.resizable()
                            
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, minHeight: 120)
                        .clipped()
                        
                    }
                }
                .padding(.top,5)
                //.padding(.horizontal, 8)
                .frame(maxWidth: .infinity)
                .background(.black)
               
                
                
                    HStack(spacing: 24) {
                        HStack(spacing: 4) {
                            Image(systemName: "heart")
                            
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
                    .padding(.horizontal, 2)
                
                Divider()
                    .frame(height: 2)
                    .background(Color.white.opacity(0.5))
                    .padding(.top, 5)
                  
                
            }
            .padding(.horizontal, 2)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
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
      PostScreen(post: samplePost)
}
