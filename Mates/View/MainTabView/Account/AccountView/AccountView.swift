//
//  AccountView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//


/**
 * This view shows  all the information, posts of the current user i.e. the user
 * who's account is logged in
 */

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
   
    
    @State private var hasInitiallyFetched: Bool = false
    @State private var isFetchingInitial: Bool = false
    
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
                                AsyncImage(url: URL(string: userSession.currentUser?.profileImageUrl ?? "")){ image in
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
                                if let major = user?.major, !major.isEmpty {
                                    Text("Majoring in \(major)")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                //user Bio: Optional
                                Text(user?.safeBio ?? "")
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
                                        PostDetailView(post: $userPosts[index], user: user, onPostDeleted: {
                                            updateCachePost(withId: userPosts[index].id)
                                        })
                                            .onAppear {
                                                if index == userPosts.count - 1 {
                                                    Task {
                                                        await fetchMoredata()
                                                    }
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
                        await refreshUserProfile()
                    }
                    
                }
            }
            .task{
                await initializeViewIfNeeded()
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
    
    private func initializeViewIfNeeded() async {
      
          if let user = userSession.currentUser, !userSession.cachedPosts.isEmpty {
              self.user = user
              self.userPosts = userSession.cachedPosts
              self.showResult = true
              self.hasInitiallyFetched = true
              return
          }
          
     
          if !hasInitiallyFetched && !isFetchingInitial {
              print("First time initialization - fetching data")
              hasInitiallyFetched = true
              await fetchUserProfile()
          }
      }
    
    //fetches initial account profile data
    private func fetchUserProfile() async {
        
        
        guard !isFetchingInitial else {
          print("Already fetching initial data, skipping...")
          return
        }
        
        isLoading = true
        showResult = false
        currentOffset = 0
        hasMoreResults = true
        
        print("fetching the user profile once")
        
        let result = await AccountService.getAccountInfo(limit: limit,offset: 0)
         
                
        isFetchingInitial = false
        isLoading = false
                
        switch result{
        case .success(let data):
          self.userPosts = data.posts
          self.user = data.userProfile
          self.hasMoreResults = userPosts.count == limit
          self.currentOffset = userPosts.count
          self.showResult = true
          self.userSession.currentUser = data.userProfile
          self.userSession.cachedPosts = data.posts
        case .failure(let error):
          self.userPosts = []
          self.showResult = true
          self.alertMessage = error.localizedDescription
          print("failed to fetched user profile")
      
        }
      }
    
    
    
    //fetches more data when the user scrolls down
    private func fetchMoredata() async{
        
        guard !isFetchingMore, hasMoreResults else { return }
        
        isFetchingMore = true
        
        let result = await AccountService.getAccountInfo(limit: limit, offset: currentOffset)
        
        
        switch result {
            
        case .success(let data):
            //append the new post in the userPost and cached it
            self.userPosts.append(contentsOf: data.posts)
            self.userSession.cachedPosts.append(contentsOf: data.posts)
            
            
            self.hasMoreResults = data.posts.count == limit
            self.currentOffset += data.posts.count
            
        case .failure(let error):
            self.alertMessage = error.localizedDescription
            
            isFetchingMore = false
        }
    }
    
    /**
     * This function gets trigger when the user refresh the screen and
     * it clears all the cached user data and posts then fetch the user
     * profile again
    **/
     
     private func  refreshUserProfile() async {
        
        //clear all the cache
        userSession.currentUser = nil
        userSession.cachedPosts = []
        
        
        user = nil
        userPosts = []
        currentOffset = 0
        hasMoreResults = true
        showResult = false
        
         hasInitiallyFetched = false
         isFetchingInitial = false
         
        //fetch the user Profile again
        await fetchUserProfile()
    }
    
    
    //deletes the post from both local and cache data
    private func updateCachePost(withId postId: String){
        
        //deletes the post from local data
        userPosts.removeAll{ $0.id == postId}
        
        //deletes the cache post
        userSession.cachedPosts.removeAll{ $0.id == postId}
        
        print("Post \(postId) removed from UI and cache.")
    }
}





#Preview {
   
    AccountView()
        .environmentObject(UserSession())
}
