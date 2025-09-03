//
//  FeedListScreen.swift
//  Mates
//
//  Created by Anurag Shrestha on 8/26/25.
//
import SwiftUI


struct FeedListScreen: View {
    @ObservedObject var vm: FeedViewModel

    
    
    var body: some View {
        VStack(spacing: 0) {
            if vm.visiblePosts.isEmpty {
                Text("No posts loaded")
                    .foregroundColor(.white)
            } else {
                ForEach(vm.visiblePosts) { post in
                    if let binding = vm.binding(for: post.id) {
                        PostScreen(post: binding)
                        .padding(.bottom, 20)
                        .onAppear {
                            if let idx = vm.visiblePosts.firstIndex(where: {$0.id == post.id}),
                               vm.shouldLoadMore(currentIndex: idx) {
                                Task { await vm.loadMore() }
                            }
                        }
                        .onDisappear { vm.markPostSeen(post) }
                    }
                }
                if vm.isLoadingMore {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .padding()
                }
                if !vm.hasMorePosts && !vm.visiblePosts.isEmpty {
                    Text("No more posts available")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                        .padding()
                }
            }
        }
        .onAppear {
            // For logging/metrics
            print("\(vm.kind.title) showing \(vm.visiblePosts.count) posts (filtered)")
        }
    }
}
