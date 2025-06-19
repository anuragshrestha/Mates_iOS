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
    @Published var user: [UserModel] = []
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    
    func laodAroundYouFeed() async {
        
        isLoading = true
        
        defer{isLoading = false}
        
        do {
            let data = try await AroundYouService.shared.fetchHomeFeed()
            self.posts = data.posts
            self.user = data.user
            
            if data.posts.isEmpty {
                self.errorMessage = "No post"
                self.showError = true
            }
            
        }catch {
            self.errorMessage = "Something went wrong. \n Please signin again."
            self.showError = true
        }
    }
}
