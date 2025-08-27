//
//  FeedKind .swift
//  Mates
//
//  Created by Anurag Shrestha on 8/26/25.
//

enum FeedKind {
    case aroundYou
    case forYou
    
    var path: String {
        switch self {
        case .aroundYou: return "/aroundyou"
        case .forYou:    return "/foryou"
        }
    }
    
    var title: String {
        switch self {
        case .aroundYou: return "Around you"
        case .forYou:    return "For you"
        }
    }
}
