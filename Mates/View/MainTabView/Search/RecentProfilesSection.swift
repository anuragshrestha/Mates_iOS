//
//  RecentProfilesSection.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/28/25.
//

import SwiftUI

struct RecentProfilesSection: View {
    
    @StateObject private var recentProfilesManager = RecentProfileCacheManager.shared
    @StateObject private var currentUserManager = CurrentUserManager.shared
    
    
    var body: some View {
        
      Group{
           if currentUserManager.hasCurrentUser() {
              let recentProfiles = recentProfilesManager.getRecentProfilesForCurrentUser()
              
              if !recentProfiles.isEmpty {
                  VStack(alignment: .leading, spacing: 15) {
                      
                      HStack {
                          Text("Recent search")
                              .font(.headline)
                              .foregroundColor(.white)
                      }
                      .padding(.horizontal)
                      
                      ScrollView {
                          LazyVStack(spacing: 12) {
                              ForEach(recentProfiles.prefix(5)) { profile in
                                  NavigationLink(destination: UserProfileView(user: profile.visitedUserData)) {
                                      RecentProfileSearchRow(profile: profile)
                                  }
                                  .buttonStyle(PlainButtonStyle())
                              }
                          }
                          .padding(.horizontal)
                      }
                  }
                  .transition(.opacity)
                  
              } else {
                  // Empty state for recent profiles
                  HStack(spacing: 2) {
                      Image(systemName: "clock.fill")
                          .font(.system(size: 14))
                          .foregroundColor(.gray)
                      
                      Text("No Recent search")
                          .font(.system(size: 14, weight: .medium))
                          .foregroundColor(.white)
                      
                  }
                  .frame(maxWidth: .infinity)
                  .padding(.top, 60)
              }
            } else {
                // User not loaded state
                VStack(spacing: 15) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    
                    Text("Loading...")
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
            }
        }
    }
}



#Preview {
    RecentProfilesSection()
        .background(Color.black)
}
