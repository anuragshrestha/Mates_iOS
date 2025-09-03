//
//  HomeScreen.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/18/25.
//

import Foundation


struct CurrentUser: Identifiable, Decodable{
    
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
    }
}

//Post model to show in the Around you screen
struct PostModel: Identifiable, Decodable {
    let id: UUID
    var email: String
    var mediaUrls:[MediaItem]?
    let createdAt: String
    var status:String
    let userId: String
    var universityName: String
    var fullName: String
    var profileImageUrl: String
    var likes: Int
    var comments: Int
    var hasLiked: Bool
    var major: String
    var schoolYear: String
    var bio: String?
    
    
    var safeBio: String {
          return bio ?? ""
      }
    
 enum CodingKeys:String, CodingKey {
    case id = "post_id"
    case email
    case mediaUrls = "media_urls"
    case createdAt = "created_at"
    case status
    case userId = "user_id"
    case universityName = "university_name"
    case fullName = "full_name"
    case profileImageUrl = "profile_image_url"
    case likes
    case comments
    case hasLiked
    case major
    case schoolYear = "school_year"
    case bio
  }
}



struct UserModel: Identifiable, Decodable, Hashable {
    let id: String
    let email: String
    var fullName: String
    let universityName: String
    var major: String
    var schoolYear: String
    let createdAt: String
    var profileImageUrl: String
    var bio: String?
 
    var safeBio: String {
          return bio ?? ""
      }
    
    
    enum CodingKeys: String, CodingKey{
        case id = "user_id"
        case email
        case fullName = "full_name"
        case universityName = "university_name"
        case major
        case schoolYear = "school_year"
        case createdAt = "created_at"
        case profileImageUrl = "profile_image_url"
        case bio
        
    }
    
}





