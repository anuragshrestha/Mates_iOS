//
//  AccountModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/30/25.
//

import Foundation

struct MediaItem: Decodable {
    let url: String
    let type: String
}



/**
 * Model for current user post data which is shown in the user account profile
 */
struct UserPostModel: Identifiable, Decodable {
    let id: String
    var mediaUrls:[MediaItem]?
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


/**
 * Model for current user Profile data which is shown in the user Account view
 */
struct UserAccountModel: Identifiable, Hashable, Decodable {
    let id: UUID
    let email: String
    let fullName: String
    let universityName: String
    let major: String
    let schoolYear: String
    let createdAt: String
    let profileImageUrl: String
    let postCount:Int
    let followersCount: Int
    let followingCount: Int
 

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email
        case fullName = "full_name"
        case universityName = "university_name"
        case major
        case schoolYear = "school_year"
        case createdAt = "created_at"
        case profileImageUrl = "profile_image_url"
        case postCount
        case followersCount
        case followingCount

    }
}


