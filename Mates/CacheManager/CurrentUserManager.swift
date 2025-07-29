//
//  CurrentUserManager.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/28/25.
//
//  Global manager to access current user information from anywhere in the app
//

import Foundation
import SwiftUI

class CurrentUserManager: ObservableObject {
    static let shared = CurrentUserManager()
    
    @Published var currentUser: CurrentUser?
    @Published var isUserLoaded: Bool = false
    
    private init() {}
    
    // Set the current user
    func setCurrentUser(_ user: CurrentUser) {
        DispatchQueue.main.async {
            self.currentUser = user
            self.isUserLoaded = true
        }
        print("Current user set: \(user.id)")
    }
    
    // Get current user ID
    func getCurrentUserId() -> String? {
        return currentUser?.id
    }
    
    // Check if current user is loaded
    func hasCurrentUser() -> Bool {
        return currentUser != nil
    }
    
    // Clear current user (call when logging out)
    func clearCurrentUser() {
        DispatchQueue.main.async {
            self.currentUser = nil
            self.isUserLoaded = false
        }
        
        // Also clear recent profiles cache when user logs out
       // SimpleRecentProfileCacheManager.shared.clearRecentProfiles()
        print("Current user cleared")
    }
    
    // Update current user data
    func updateCurrentUser(_ user: CurrentUser) {
        setCurrentUser(user)
    }
}
