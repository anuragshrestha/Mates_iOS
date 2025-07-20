//
//  AccountView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var userSession: UserSession
    
    @State private var path = NavigationPath()
    @State var userPosts: [UserPostModel] = []
    @State  var user: UserAccountModel? = nil
    @AppStorage("isSignedIn") var isSignedIn:Bool = false
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State private var isLoading:Bool = false
    @State private var showResult: Bool = false
    @State private var currentOffset = 0
    @State private var isFetchingMore = false
    @State private var hasMoreResults = true
   
    
    private let limit = 2
    
    
  
    enum AccountRoute: Hashable {
        case settings
    }
    
    
    var body: some View {
    
        NavigationStack(path: $path){
            
            
            ZStack(alignment: .leading){
                
                Color.black.opacity(0.95).ignoresSafeArea()
                
                
                //shows progress view until the data is fetched
                if isLoading{
                    
                    VStack{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(2)
                        
                        Text("Loading...")
                            .font(.system(size: 18))
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)
                            .padding(.top, 5)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else if showResult{
                    ScrollView{
                        VStack(alignment: .leading){
                            
                            HStack(alignment: .top) {
                                Text(user?.fullName ?? "")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button {
//                                    navigateToSetting = true
                                    path.append(AccountRoute.settings)
                                    print("navigating to account setting")
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
                                AsyncImage(url: URL(string: user?.profileImageUrl ?? "")){ image in
                                    image.image?.resizable()
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                
                                
                                Spacer()
                                
                                //shows posts count
                                VStack(spacing: 4){
                                    Text("\(user?.postCount ?? 0)")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("POSTS")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                Spacer()
                                
                                //shows followers count
                                VStack(spacing: 4) {
                                    Text("\(user?.followersCount ?? 0)")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("FOLLOWERS")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                Spacer()
                                
                                //shows following count
                                VStack(spacing: 4){
                                    Text("\(user?.followingCount ?? 0)")
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
                                Text(user?.fullName ?? "")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                                
                                //user university name
                                if let year = user?.schoolYear, let uni = user?.universityName {
                                    Text("\(year) @ \(uni)")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                    
                                } else {
                                    Text(user?.schoolYear ?? user?.universityName ?? "")
                                }
                                
                                
                                //user major
                                Text(user?.major ?? "")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                
                                //user Bio: Optional
                                Text(user?.bio ?? "CS guy!")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .medium))
                                
                                
                            }
                            .padding(.horizontal)
                            
                            
                            Divider()
                                .frame(maxWidth: .infinity, maxHeight: 1)
                                .background(Color.darkGray)
                                .padding(.bottom, 2)
                            
                            LazyVStack{
                                if let user = user{
                                    ForEach(userPosts.indices, id: \.self) { index in
                                        PostDetailView(post: $userPosts[index], user: user)
                                            .onAppear {
                                                if index == userPosts.count - 1 {
                                                    fetchMoredata()
                                                }
                                                
                                            }
                                    }
                                    
                                    if isFetchingMore {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .padding()
                                    }
                                }
                            }
                         
                        }
                    }
                    .padding(.bottom, 10)
                    .refreshable {
                        refreshUserProfile()
                    }
                    
                }
                
                
                
                
            }
            .onAppear{
                if let user = userSession.currentUser, !userSession.cachedPosts.isEmpty {
                    self.user = user
                    self.userPosts = userSession.cachedPosts
                    self.showResult = true
                }else{
                    fetchUserProfile()
                }
               
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
            .navigationDestination(for: AccountRoute.self) { route in
                           switch route {
                           case .settings:
                               AccountSetting(path: $path)
                                   .environmentObject(userSession)
                   }
               }
            
        }
    }
    
    
    //fetches initial account profile data
    private func fetchUserProfile(){
        
        isLoading = true
        showResult = false
        currentOffset = 0
        hasMoreResults = true
        
        AccountService.getAccountInfo(limit: limit,offset: 0) { result, data, message in
            DispatchQueue.main.async {
                
                isLoading = false
                
                if result, let data = data {
                    self.userPosts = data.posts
                    self.user = data.userProfile
                    self.hasMoreResults = userPosts.count == limit
                    self.currentOffset = userPosts.count
                    self.showResult = true
                    self.userSession.currentUser = data.userProfile
                    self.userSession.cachedPosts = data.posts
                }else{
                    self.userPosts = []
                    self.showResult = true
                    self.alertMessage = message ?? "Failed to fetch user profile. Please try again."
                    print("failed to fetched user profile")
                }
            }
        }
    }
    
    
    
    //fetches more data when the user scrolls down
    private func fetchMoredata(){
        
        guard !isFetchingMore, hasMoreResults else { return }
        
        isFetchingMore = true
        
        AccountService.getAccountInfo(limit: limit, offset: currentOffset) { result, data, message in
            DispatchQueue.main.async {
                isFetchingMore = false
                
                if result, let data = data {
                    
                    //append the new post in the userPost and cached it
                    self.userPosts.append(contentsOf: data.posts)
                    self.userSession.cachedPosts.append(contentsOf: data.posts)
                    
                    
                    self.hasMoreResults = data.posts.count == limit
                    self.currentOffset += data.posts.count
                }
            }
        }
    }
    
    
    /**
     * This function gets trigger when the user refresh the screen and
     * it clears all the cached user data and posts then fetch the user
     * profile again
    **/
     
     private func  refreshUserProfile() {
        
        //clear all the cache
        userSession.currentUser = nil
        userSession.cachedPosts = []
        
        
        user = nil
        userPosts = []
        currentOffset = 0
        hasMoreResults = true
        showResult = false
        
        //fetch teh user Profile again
        fetchUserProfile()
    }
}





#Preview {
   
    AccountView()
        .environmentObject(UserSession())
}
