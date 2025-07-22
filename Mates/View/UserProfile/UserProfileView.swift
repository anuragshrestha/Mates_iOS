//
//  UserProfileView.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/26/25.
//

/**
 * This view displays all the information, posts of a user when we view their profile page
 */

import SwiftUI

struct UserProfileView: View {
    
    @Environment(\.dismiss) private var dismiss
    let user: UserModel
    @State var userProfileData: UserProfileResponse? = nil
    @State private var userPosts: [UserProfilePostModel] = []
    @State var showUserProfileData: Bool = false
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State var unFollowUser:Bool = false
    @State var showUnfollowAlert:Bool = false
    
    // State to track the swipe gesture for dismissal
     @State private var dragOffset: CGSize = .zero
    
    
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
                                .frame(width: 160, height: 160)
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
                            
                            //bio
                            Text(user.safeBio)
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .medium))
                            
                        }
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        
                        if !showUserProfileData{
                            LoopingProgressBar()
                        }else{
                            
                            
                            if userProfileData?.isFollowing == true {
                          
                                Button(action: {
                                    showUnfollowAlert = true
                                }) {
                                    Text("Following")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.gray)
                                        .cornerRadius(12)
                                }
                                
                            } else if userProfileData?.isFollowing == false && userProfileData?.isFollowed == true {
                                Button(action: {
                                    print("is follow back pressed")
                                    FollowUnfollowUser.shared.followUser(userId: user.id.uuidString) { success, message in
                                        DispatchQueue.main.async{
                                            if success {
                                                userProfileData?.isFollowing = true
                                                userProfileData?.followersCount += 1
                                            }
                                        }
                                        
                                    }
                                }) {
                                    Text("Follow Back")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                        .cornerRadius(12)
                                }
                                
                            }else if userProfileData?.isFollowing == false && userProfileData?.isFollowed == false {
                                //Button to follow/unfollow the user
                                Button(action: {
                                    print("pressed the follow button")
                                    FollowUnfollowUser.shared.followUser(userId: user.id.uuidString) { success, message in
                                        DispatchQueue.main.async{
                                            if success {
                                                userProfileData?.isFollowing = true
                                                userProfileData?.followersCount += 1
                                            }
                                        }
                                    }
                                }) {
                                    Text("Follow")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue)
                                        .cornerRadius(12)
                                }
                                
                            }
                            
                            
                            
                            //Shows the users current posts count and followers count
                            HStack(spacing: 16){
                                
                                //VStack for posts count
                                VStack{
                                    if let data = userProfileData {
                                        Text("\(data.postCount)")
                                            .font(.system(size: 22, weight: .bold))
                                            .foregroundColor(.white)
                                    }else{
                                        Text("0")
                                            .font(.system(size: 22, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    
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
                                
                                
                                //VStack for follower count
                                VStack{
                                    if let data = userProfileData{
                                        Text("\(data.followersCount)")
                                            .font(.system(size:22, weight: .bold))
                                            .foregroundColor(.white)
                                    }else{
                                        Text("0")
                                            .font(.system(size: 22, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                    }
                                    
                                    
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
                                
                                
                                //VStack for following counts
                                VStack{
                                    
                                    if let data = userProfileData{
                                        Text("\(data.followingCount)")
                                            .font(.system(size:22, weight: .bold))
                                            .foregroundColor(.white)
                                    }else{
                                        Text("0")
                                            .font(.system(size: 22, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    
                                    
                                    Text("Following")
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
                            
                            
                        }
                        
                    
                        Divider()
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.5))
                            .padding(.top, 8)
                        
                        
                        //posts will be shown here
                        
                        if userPosts.isEmpty {
                            Text("\(user.fullName) has not posted yet.")
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.top)
                                .padding(.horizontal)
                        } else {
                            LazyVStack {
                                ForEach(userPosts.indices, id: \.self) { index in
                                    UserPostView(post: $userPosts[index], user: user)
                                }
                            }
                        }
                        
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 16)
                    .background(Color.black.opacity(0.95))
                    
                }
                .onAppear{
                    self.unFollowUser = false
                    fetchUserData()
                }
                
            }
            .alert("Are you sure?", isPresented: $showUnfollowAlert) {
                Button("No", role: .cancel){
                    self.unFollowUser = false
                }
                
                Button("Yes"){
                 
                    FollowUnfollowUser.shared.unFollowUser(userId: user.id.uuidString) { success, message in
                        if success {
                            DispatchQueue.main.async{
                                if var updatedData = self.userProfileData {
                                    updatedData.isFollowing = false
                                    if updatedData.followersCount > 0 {
                                        updatedData.followersCount -= 1
                                    }
                                   
                                    self.userProfileData = updatedData
                                }
                            }
                        }
                    }
                }
            } message: {
                Text("Do you want unfollow \(user.fullName)")
            }
            .alert("", isPresented: $showAlert) {
                Button("Ok", role: .cancel){}
            } message:{
                Text("\(alertMessage)")
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
            }
            //SWIPE TO DISMISS MODIFIERS
            .offset(x: dragOffset.width)
            .opacity(1.0 - Double(abs(dragOffset.width) / (UIScreen.main.bounds.width / 2)))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        // Only track swipes from left to right to avoid conflicts
                        if gesture.translation.width > 0 {
                            self.dragOffset = gesture.translation
                        }
                    }
                    .onEnded { gesture in
                        // If the user swiped more than a third of the screen, dismiss the view
                        if gesture.translation.width > UIScreen.main.bounds.width / 3 {
                            dismiss()
                        }
                        // Otherwise, animate the view back to its original position
                        withAnimation(.spring()) {
                            self.dragOffset = .zero
                        }
                    }
            )
        
    }
    
    func fetchUserData() {
        UserProfileService.shared.fetchUserProfile(userId: user.id.uuidString){ result in
            DispatchQueue.main.async{
                switch result {
                case .success(let userData):
                    self.userProfileData = userData
                    self.showUserProfileData = true
                    self.userPosts = userData.posts
                    print(self.userPosts)
                case .failure(_):
                    showAlert = true
                    alertMessage = "Failed to load user profile. \n Restart the app"
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
            profileImageUrl: "https://via.placeholder.com/100",
            bio: "Testing bio"
        )
        )
    
}
