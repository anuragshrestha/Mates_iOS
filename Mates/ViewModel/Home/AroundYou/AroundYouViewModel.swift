//
//  AroundYouViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/18/25.
//

import Foundation

class AroundYouServiceViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published private(set) var posts: [PostModel] = []
    @Published var seenPostIDs: Set<String> = []
    @Published var userId: String?
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    @Published var hasMorePosts: Bool = true
       
    private var currentPage: Int = 1
    private let pageSize: Int = 6

    /// Only fetch if posts are empty or forceRefresh is true
    @MainActor
    func laodAroundYouFeed(forceRefresh: Bool = false) async {
        guard forceRefresh || posts.isEmpty else { return }

        if forceRefresh {
             // Reset pagination state
             currentPage = 1
             hasMorePosts = true
             posts.removeAll()
             seenPostIDs.removeAll()
         }
        
        isLoading = true
        defer { isLoading = false }

        do {
            let data = try await AroundYouService.shared.fetchHomeFeed(page: currentPage, limit: pageSize)

          
            self.posts = data.posts
            self.userId = data.user_id
            self.hasMorePosts = data.hasMore ?? false
            
            CurrentUserManager.shared.setCurrentUser(CurrentUser(id: data.user_id))

            if posts.isEmpty {
                self.errorMessage = "No post"
                self.showError = true
            }
        } catch {
            print("failed to fetch the posts: \(error)")
            self.errorMessage = "Failed to load posts"
            self.showError = true
        }
    }
    
    
    
    /// Load more posts for pagination
      @MainActor
      func loadMorePosts() async {
          guard !isLoadingMore && hasMorePosts else { return }
          
          isLoadingMore = true
          defer { isLoadingMore = false }
          
          let nextPage = currentPage + 1
          
          do {
              let data = try await AroundYouService.shared.fetchHomeFeed(page: nextPage, limit: pageSize)
              
              // Filter out posts we already have
              let newPosts = data.posts.filter { newPost in
                  !posts.contains { existingPost in
                      existingPost.id == newPost.id
                  }
              }
              
              self.posts.append(contentsOf: newPosts)
              self.currentPage = nextPage
              self.hasMorePosts = data.hasMore ?? false
              
          } catch {
              print("failed to load more posts: \(error)")
              self.errorMessage = "Failed to load more posts."
              self.showError = true
          }
      }

    /// Filtered posts for display (hide seen)
    var visiblePosts: [PostModel] {
        let unseen = posts.filter { !seenPostIDs.contains($0.id.uuidString) }
        return unseen.isEmpty ? posts : unseen
    }

    /// Mark post as seen
    func markPostSeen(_ post: PostModel) {
        seenPostIDs.insert(post.id.uuidString)
    }
    
    /// Check if we should load more posts when user reaches near the end
    func shouldLoadMorePosts(currentIndex: Int) -> Bool {
          return currentIndex >= visiblePosts.count - 1 && hasMorePosts && !isLoadingMore
    }
}
