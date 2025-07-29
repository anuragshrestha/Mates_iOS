//
//  AppConfig.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/26/25.
//


import Foundation

struct Config {
    static var baseURL: String {
#if targetEnvironment(simulator)
        return "http://localhost:4000"
#else
        return "http://\(Config.localIPAddress):4000"
#endif
    }

    static var localIPAddress: String {
    
        return "10.88.151.51"
    }
}
