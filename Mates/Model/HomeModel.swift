//
//  HomeScreen.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/18/25.
//

import Foundation

struct PostModel: Identifiable, Decodable {
    let id: UUID
    var email: String
    var imageUrl:String?
    let createdAt: String
    var status:String
    let userId: String
    var universityName: String
    var fullName: String
    var profileImageUrl: String
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
    case fullName = "full_name"
    case profileImageUrl = "profile_image_url"
    case likes
    case comments
    case hasLiked
  }
}



struct UserModel: Identifiable, Decodable {
    let id: UUID
    let email: String
    let fullName: String
    let universityName: String
    let major: String
    let schoolYear: String
    let createdAt: String
    let profileImageUrl: String
    
    enum CodingKeys: String, CodingKey{
        case id = "user_id"
        case email
        case fullName = "full_name"
        case universityName = "university_name"
        case major
        case schoolYear = "school_year"
        case createdAt = "created_at"
        case profileImageUrl = "profile_image_url"
        
    }
    
}





