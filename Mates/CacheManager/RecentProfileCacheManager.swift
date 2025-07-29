//
//  RecentProfileCacheManager.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/28/25.
//
//  Simple in-memory cache for recent profile visits that resets when app closes
//

import Foundation

class RecentProfileCacheManager: ObservableObject {
    static let shared = RecentProfileCacheManager()
    
    private let maxRecentProfiles = 5
    @Published var recentProfiles: [SimpleRecentProfileModel] = []
    
    private init() {}
    
    
    // Adds a visited profile to recent list
    func addRecentProfile(visitedUser: UserModel) {
        
        // Get current user ID from global manager
        guard let currentUserId = CurrentUserManager.shared.getCurrentUserId() else {
            print("No current user ID available")
            return
        }
        
        //checks if the visited id if of the same current user
        if currentUserId == visitedUser.id {
            return
        }
        
        let recentProfile = SimpleRecentProfileModel(
            currentUserId: currentUserId,
            visitedUserId: visitedUser.id,
            visitedUserData: visitedUser,
            visitedAt: Date()
        )
        
        // Remove if already exists to avoid duplicates
        recentProfiles.removeAll { $0.visitedUserId == visitedUser.id && $0.currentUserId == currentUserId }
        
        // Inserts at the beginning
        recentProfiles.insert(recentProfile, at: 0)
        
        // Keeps only the most recent 5
        if recentProfiles.count > maxRecentProfiles {
            recentProfiles = Array(recentProfiles.prefix(maxRecentProfiles))
        }
        
        print("Added recent profile visit: \(currentUserId) visited \(visitedUser.fullName)")
        print("Total recent profiles: \(recentProfiles.count)")
    }
    
    
    // Get recent profiles for current user
    func getRecentProfilesForCurrentUser() -> [SimpleRecentProfileModel] {
        guard let currentUserId = CurrentUserManager.shared.getCurrentUserId() else {
            return []
        }
        return recentProfiles.filter { $0.currentUserId == currentUserId }
    }
    
    // Clear all recent profiles
    func clearRecentProfiles() {
        recentProfiles.removeAll()
        print("Cleared all recent profiles")
    }
    
    // Remove specific profile
    func removeRecentProfile(visitedUserId: String) {
        guard let currentUserId = CurrentUserManager.shared.getCurrentUserId() else {
            return
        }
        recentProfiles.removeAll { $0.currentUserId == currentUserId && $0.visitedUserId == visitedUserId }
        print("Removed recent profile: \(visitedUserId)")
    }
    
    // Get count of recent profiles for current user
    func getRecentProfilesCount() -> Int {
        return getRecentProfilesForCurrentUser().count
    }
}

//Simple Recent Profile Model
struct SimpleRecentProfileModel: Identifiable {
    let id = UUID()
    let currentUserId: String
    let visitedUserId: String
    let visitedUserData: UserModel
    let visitedAt: Date
}

//Date Extension for time formatting
extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
