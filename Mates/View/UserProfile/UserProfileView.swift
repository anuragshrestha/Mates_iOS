//
//  UserProfileView.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/26/25.
//

import SwiftUI

struct UserProfileView: View {
    
    @Environment(\.dismiss) private var dismiss
    let user: UserModel
    
    var body: some View {
        
        ZStack(alignment: .leading){
            Color.black.opacity(0.95).ignoresSafeArea()
            
            ScrollView{
                VStack(alignment: .leading, spacing: 16) {
                  
                  
                    /**
                     * Includes the Profile image, full name, university name, major
                     */
                    VStack(alignment: .center, spacing: 8){
                        
                        if let url = URL(string: user.profileImageUrl), !user.profileImageUrl.isEmpty {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            
                        }else{
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width:50, height: 50)
                                .foregroundColor(.gray)
                                .font(.system(size: 50))
                        }
                        
                        Text(user.fullName)
                            .font(.system(size: 30))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.9)
                            .truncationMode(.tail)
                
        
                        
                        Text("\(user.schoolYear) at \(user.universityName)")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.8))
                            .fontWeight(.regular)
                            .lineLimit(1)
                            .minimumScaleFactor(0.9)
                            .truncationMode(.tail)
                        
                        Text("\(user.major)")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.8))
                            .fontWeight(.regular)
                            .lineLimit(1)
                            .minimumScaleFactor(0.9)
                            .truncationMode(.tail)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                      
        
                    //Button to follow/unfollow the user
                    Button(action: {
                        print("pressed the follow button")
                    }) {
                        Text("Follow")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    
                    //Shows the users current posts count and followers count
                    HStack(spacing: 16){
                        VStack{
                            
                            Text("120")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Posts")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity, maxHeight: 80)
                        .background(Color.white.opacity(0.2))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.6), lineWidth: 1)
                        )
                        .cornerRadius(12)
                        
                    
                        VStack{
                            Text("520")
                                .font(.system(size:22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Followers")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity, maxHeight: 80)
                        .background(Color.white.opacity(0.2))
                        .overlay (
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.6), lineWidth: 1)
                        )
                        .cornerRadius(12)
                    
                    }
                    
               
                    Divider()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.5))
                        .padding(.top, 8)
                 
            
                 //posts will be shown here
                    
                    
                }
                .padding(.top, 20)
                .padding(.horizontal, 16)
            }
           
        }
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading){
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
            }
        }
    }
}

#Preview {
    UserProfileView(user: UserModel(
        id: UUID(),
        email: "example@example.com",
        fullName: "Anurag Shrestha",
        universityName: "Harvard University",
        major: "Computer Science",
        schoolYear: "Senior",
        createdAt: "2025-06-25",
        profileImageUrl: "https://via.placeholder.com/100"
    ))
}
