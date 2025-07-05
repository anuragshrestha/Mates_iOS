//
//  AccountModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/30/25.
//

import Foundation


struct UserPostModel: Identifiable, Decodable {
    let id: UUID
    var imageUrl:String?
    let createdAt: String
    var status:String
    var fullName: String
    var profileImageUrl: String
    var likes: Int
    var comments: Int
    var hasLiked: Bool
    
    
 enum CodingKeys:String, CodingKey {
    case id = "post_id"
    case imageUrl = "image_url"
    case createdAt = "created_at"
    case status
    case fullName = "full_name"
    case profileImageUrl = "profile_image_url"
    case likes
    case comments
    case hasLiked

  }
}
