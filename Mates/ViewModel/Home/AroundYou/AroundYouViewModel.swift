//
//  AroundYouViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/18/25.
//

import Foundation

class AroundYouServiceViewModel: ObservableObject {
    
    @Published var isLoading:Bool = false
    @Published var posts: [PostModel] = []
    @Published var user: UserModel? = nil
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    
    @MainActor
    func laodAroundYouFeed() async {
        
        isLoading = true
        
        defer{isLoading = false}
        
        do {
            let data = try await AroundYouService.shared.fetchHomeFeed()
            self.posts = data.posts
            self.user = data.user
            
            print("Fetched posts: \(data.posts.count)")
            for post in data.posts {
                print("Post: \(post.status), by \(post.fullName)")
            }
            
            if data.posts.isEmpty {
                self.errorMessage = "No post"
                self.showError = true
            }
            
        }catch {
            print("failed to fetch the posts")
            self.errorMessage = "Something went wrong. \n Please signin again."
            self.showError = true
        }
    }
}
