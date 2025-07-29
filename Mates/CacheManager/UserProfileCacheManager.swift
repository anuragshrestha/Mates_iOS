import Foundation

struct CachedProfileData {
    let data: UserProfileResponse
    let timestamp: Date
}

class UserProfileCacheManager {
    
    static let shared = UserProfileCacheManager()
    
    private init(){}
    
    // Updated to store data with timestamps
    private var profileCache: [String: CachedProfileData] = [:]
    
    // Cache expiration time (5 minutes)
    private let cacheExpirationTime: TimeInterval = 300
    
    
    // Returns cached profile data if it exists and hasn't expired
    func getCachedProfile(for userId: String) -> UserProfileResponse? {
        
        
        let userIdString = userId
        
        guard let cachedData = profileCache[userIdString] else {
            return nil // No cached data
        }
        
        // Check if cache has expired
        let currentTime = Date()
        let timeSinceCache = currentTime.timeIntervalSince(cachedData.timestamp)
        
        if timeSinceCache > cacheExpirationTime {
            // Cache expired, remove it
            profileCache.removeValue(forKey: userIdString)
            return nil
        }
        
        return cachedData.data
    }
    
    
    // Caches the user profile data with current timestamp
    func setCachedProfile(_ data: UserProfileResponse, for userId: String) {
        let userIdString = userId
        let cachedData = CachedProfileData(data: data, timestamp: Date())
        profileCache[userIdString] = cachedData
    }
    
    
    // Removes all cached data
    func clearCache() {
        profileCache.removeAll()
    }
    
}
