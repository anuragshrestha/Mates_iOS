//
//  AroundYouViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/18/25.
//

import Foundation

class AroundYouServiceViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published private(set) var posts: [PostModel] = []
    @Published var seenPostIDs: Set<String> = []
    @Published var userId: String?
    @Published var errorMessage: String?
    @Published var showError: Bool = false

    /// Only fetch if posts are empty or forceRefresh is true
    @MainActor
    func laodAroundYouFeed(forceRefresh: Bool = false) async {
        guard forceRefresh || posts.isEmpty else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let data = try await AroundYouService.shared.fetchHomeFeed()

            // Append only new posts
            let newPosts = data.posts.filter { !seenPostIDs.contains($0.id.uuidString) }
            self.posts.append(contentsOf: newPosts)

            self.userId = data.user_id
            CurrentUserManager.shared.setCurrentUser(CurrentUser(id: data.user_id))

            if posts.isEmpty {
                self.errorMessage = "No post"
                self.showError = true
            }
        } catch {
            print("failed to fetch the posts: \(error)")
            self.errorMessage = "Something went wrong. \n Please signin again."
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
}
