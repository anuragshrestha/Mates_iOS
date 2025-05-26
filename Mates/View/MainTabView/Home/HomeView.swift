//
//  HomeView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//

import SwiftUI

import SwiftUI

struct Post: Identifiable {
    let id = UUID()
    let name: String
    let avatar: String
    let time: String
    let text: String
    let imageName: String?  // optional
    let likes: Int
    let comments: Int
    let shares: Int
}

struct HomeView: View {
    
    let posts: [Post] = [
        Post(name: "Ethan Carter", avatar: "ethan", time: "1d", text: "I'm looking for a study group for my Calculus class. Anyone interested?", imageName: "math", likes: 23, comments: 5, shares: 2),
        Post(name: "Sophia Clark", avatar: "sophia", time: "2d", text: "Just finished a great workout at the campus gym! Feeling energized and ready to tackle the day.", imageName: nil, likes: 18, comments: 3, shares: 1),
        Post(name: "Ethan Harper", avatar: "ethan2", time: "2d", text: "Anyone else feel like the dining hall food has been extra bland lately? I swear, they’ve been skimping on the seasoning. #CollegeLife #FoodieProblems", imageName: "food", likes: 23, comments: 12, shares: 5),
        Post(name: "Olivia Bennett", avatar: "olivia", time: "4d", text: "Spent the afternoon volunteering at the local community center. It's always rewarding to give back.", imageName: nil, likes: 29, comments: 6, shares: 3),
        Post(name: "Bekker kelly", avatar: "olivia", time: "4d", text: "Spent the afternoon volunteering at the local community center. It's always rewarding to give back.", imageName: nil, likes: 29, comments: 6, shares: 3),
        Post(name: "James Mathew", avatar: "olivia", time: "4d", text: "Spent the afternoon volunteering at the local community center. It's always rewarding to give back.", imageName: nil, likes: 29, comments: 6, shares: 3)
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(posts) { post in
                        PostScreen(post:post)
                            .padding(.bottom, 20)
                            
                          
                    }
                }
               
            }
        }
    }
}
#Preview {
    HomeView()
}
