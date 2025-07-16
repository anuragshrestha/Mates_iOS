//
//  UserSession.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/15/25.
//

import Foundation

class UserSession: ObservableObject {
    @Published var currentUser: UserAccountModel? = nil
}
