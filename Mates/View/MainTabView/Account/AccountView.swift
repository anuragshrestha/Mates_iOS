//
//  AccountView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//

import SwiftUI

struct AccountView: View {
    
    
    @State var userPosts: [UserPostModel] = []
    @State  var user: UserAccountModel? = nil
    @StateObject var signOutVM = SignOutViewModel()
    @AppStorage("isSignedIn") var isSignedIn:Bool = false
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State private var isLoading:Bool = false
    @State private var showResult: Bool = false
    @State private var currentOffset = 0
    @State private var isFetchingMore = false
    @State private var hasMoreResults = true
    
    private let limit = 2
    
    
    
   
    
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
                            //
                            
                        }
                    }
                    .padding(.horizontal, 2)
                    .padding(.bottom, 20)
                    
                    
                    
                }
            }
        }
        .onAppear{
            fetchUserProfile()
        }
    }
    
    
    private func fetchUserProfile(){
        
        isLoading = true
        showResult = false
        currentOffset = 0
        hasMoreResults = true
        
        AccountService.getAccountInfo(limit: limit,offset: 0) { result, data, message in
            DispatchQueue.main.async {
                
                isLoading = true
                
                if result, let data = data {
                    self.userPosts = data.posts
                    self.user = data.userProfile
                    self.hasMoreResults = userPosts.count == limit
                    self.currentOffset = userPosts.count
                }else{
                    self.userPosts = []
                    self.showResult = true
                    print("failed to fetched user profile")
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
