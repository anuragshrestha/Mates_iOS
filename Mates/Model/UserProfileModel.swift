//
//  UserProfileModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/28/25.
//

import Foundation


struct MediaItem1: Decodable, Equatable {
    let url: String
    let type: String
}


//Model for the posts being shownn inside other user profile view
struct UserProfilePostModel: Identifiable, Decodable, Equatable {
    let id: String
    var mediaUrls:[MediaItem1]?
    let createdAt: String
    var status:String
    var likes: Int
    var comments: Int
    var hasLiked: Bool
    
    
 enum CodingKeys:String, CodingKey {
    case id = "post_id"
    case mediaUrls = "media_urls"
    case createdAt = "created_at"
    case status
    case likes
    case comments
    case hasLiked

  }
}


//Model for the user profile view except the user personal data
struct UserProfileResponse: Decodable, Equatable  {
    let success: Bool
    var user_id: String
    var followersCount: Int
    var followingCount: Int
    var postCount: Int
    var isFollowing: Bool
    var isFollowed: Bool
    var posts: [UserProfilePostModel]
    
}
