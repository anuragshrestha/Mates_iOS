//
//  UserProfileModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/28/25.
//

import Foundation

//Model for the posts being shownn inside user profile
struct UserProfilePostModel: Identifiable, Codable {
    let id: UUID
    var email: String
    var imageUrl:String?
    let createdAt: String
    var status:String
    let userId: String
    var universityName: String
    var likes: Int
    var comments: Int
    var hasLiked: Bool
    
 enum CodingKeys:String, CodingKey {
    case id = "post_id"
    case email
    case imageUrl = "image_url"
    case createdAt = "created_at"
    case status
    case userId = "user_id"
    case universityName = "university_name"
    case likes
    case comments
    case hasLiked
  }
}


//Model for the user profile view except the user personal data
struct UserProfileResponse: Codable {
    let success: Bool
    var user_id: String
    var followersCount: Int
    var followingCount: Int
    var postCount: Int
    var isFollowing: Bool
    var isFollowed: Bool
    var posts: [UserProfilePostModel]
    
}
