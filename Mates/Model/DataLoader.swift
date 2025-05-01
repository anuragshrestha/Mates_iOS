//
//  DataLoader.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/22/25.
//

import Foundation

class DataLoader {
    static func loadArray(from filename: String) -> [String] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let array = try? JSONSerialization.jsonObject(with: data) as? [String] else {
            print("Failed to load \(filename).json")
            return []
        }
        return array
    }

    static func loadUniversityNames() -> [String] {
        guard let url = Bundle.main.url(forResource: "universities", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let jsonData = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            print("Failed to load universities.json")
            return []
        }
        return jsonData.compactMap { $0["name"] as? String }
    }
}
