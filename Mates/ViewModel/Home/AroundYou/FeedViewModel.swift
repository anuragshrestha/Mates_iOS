//
//  AroundYouViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/18/25.
//
import SwiftUI
import Foundation

@MainActor
final class FeedViewModel: ObservableObject {
    let kind: FeedKind
    
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published private(set) var posts: [PostModel] = []
    @Published var seenPostIDs: Set<String> = []
    @Published var userId: String?
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var hasMorePosts = true
    
    private var currentPage: Int = 1
    private let pageSize: Int = 6
    
    init(kind: FeedKind) {
        self.kind = kind
    }
    
    func binding(for id: UUID) -> Binding<PostModel>? {
        guard let i = posts.firstIndex(where: { $0.id == id }) else { return nil }
        return Binding(get: { self.posts[i] }, set: { self.posts[i] = $0 })
    }
    
    func loadInitial(forceRefresh: Bool = false) async {
        guard forceRefresh || posts.isEmpty else { return }
        if forceRefresh {
            currentPage = 1
            hasMorePosts = true
            posts.removeAll()
            seenPostIDs.removeAll()
        }
        isLoading = true
        defer { isLoading = false }
        do {
            let data = try await FeedService.shared.fetchFeed(kind: kind, page: currentPage, limit: pageSize)
            posts = data.posts
            userId = data.user_id
            hasMorePosts = data.hasMore ?? false
            CurrentUserManager.shared.setCurrentUser(CurrentUser(id: data.user_id))
            if posts.isEmpty {
                errorMessage = "No post"
                showError = true
            }
        } catch {
            errorMessage = "Failed to load posts"
            showError = true
        }
    }
    
    func loadMore() async {
        guard !isLoadingMore && hasMorePosts else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        let next = currentPage + 1
        do {
            let data = try await FeedService.shared.fetchFeed(kind: kind, page: next, limit: pageSize)
            let newPosts = data.posts.filter { newPost in
                !posts.contains { $0.id == newPost.id }
            }
            posts.append(contentsOf: newPosts)
            currentPage = next
            hasMorePosts = data.hasMore ?? false
        } catch {
            errorMessage = "Failed to load more posts."
            showError = true
        }
    }
    
    var visiblePosts: [PostModel] {
        let unseen = posts.filter { !seenPostIDs.contains($0.id.uuidString) }
        return unseen.isEmpty ? posts : unseen
    }
    
    func markPostSeen(_ post: PostModel) { seenPostIDs.insert(post.id.uuidString) }
    
    func shouldLoadMore(currentIndex: Int) -> Bool {
        currentIndex >= visiblePosts.count - 1 && hasMorePosts && !isLoadingMore
    }
}
