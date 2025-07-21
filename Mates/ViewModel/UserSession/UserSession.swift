//
//  UserSession.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/15/25.
//

import Foundation
import UIKit

class UserSession: ObservableObject {
    @Published var currentUser: UserAccountModel? = nil
    @Published var cachedPosts: [UserPostModel] = []
    @Published var profileImage: UIImage? = nil
}
