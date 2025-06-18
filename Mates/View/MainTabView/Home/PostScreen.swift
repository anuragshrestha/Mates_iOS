//
//  PostScreen.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/24/25.
//

import SwiftUI

struct PostScreen: View {
    
    let post: Post
    
    var body: some View {
        
        ZStack{
            //Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 4) {
                VStack(alignment: .leading, spacing: 10){
                    
                    //Profile row
                    HStack(alignment: .top, spacing: 12) {
                        Image(post.avatar)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(post.name)
                                .font(.customfont(.bold, fontSize: 18))
                                .foregroundColor(.white)
                            
                            Text(post.time)
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                        
                    }
                    
                    //Post Content
                    Text(post.text)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .padding(.horizontal, 2)
                        .padding(.bottom, 5)
                        
                       
                 
        
                    if let image = post.imageName {
                        Image(image)
                            .resizable()
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
                            
                            Text("\(post.shares)")
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
    
    let post = Post(
         name: "Ethan Harper",
         avatar: "ethan",
         time: "2d",
         text: "Anyone else feel like the dining hall food has been extra bland lately? #CollegeLife",
         imageName: nil,
         likes: 23,
         comments: 12,
         shares: 5
     )
     
     return PostScreen(post: post)
}
