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
                    HStack(alignment: .top, spacing: 12){
                        
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
                
                    }
                    .padding(.bottom, 9)
                 
                    
                    VStack(alignment: .leading, spacing: 6){
                        
                        Text("\(user.schoolYear) at \(user.universityName)")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.9))
                            .fontWeight(.regular)
                            .lineLimit(1)
                            .minimumScaleFactor(0.9)
                            .truncationMode(.tail)
                        
                        Text("Majoring in \(user.major)")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.9))
                            .fontWeight(.regular)
                            .lineLimit(1)
                            .minimumScaleFactor(0.9)
                            .truncationMode(.tail)
                        
                    }
                    .padding(.bottom, 8)
                    
                    
                    Button(action: {
                        print("pressed the follow button")
                    }) {
                        Text("Follow")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.blue)
                            .cornerRadius(12)
                        
                        
                    }
                   
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
