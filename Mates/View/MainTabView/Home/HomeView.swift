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
    
    
    @State private var lastoffset: CGFloat = 0
    @State private var hideHeader: Bool = false
    
    let posts: [Post] = [
        Post(name: "Ethan Carter", avatar: "ethan", time: "1d", text: "I'm looking for a study group for my Calculus class. Anyone interested?", imageName: "math", likes: 23, comments: 5, shares: 2),
        Post(name: "Sophia Clark", avatar: "sophia", time: "2d", text: "Just finished a great workout at the campus gym! Feeling energized and ready to tackle the day.", imageName: nil, likes: 18, comments: 3, shares: 1),
        Post(name: "Ethan Harper", avatar: "ethan2", time: "2d", text: "Anyone else feel like the dining hall food has been extra bland lately? I swear, they’ve been skimping on the seasoning. #CollegeLife #FoodieProblems", imageName: "food", likes: 23, comments: 12, shares: 5),
        Post(name: "Olivia Bennett", avatar: "olivia", time: "4d", text: "Spent the afternoon volunteering at the local community center. It's always rewarding to give back.", imageName: nil, likes: 29, comments: 6, shares: 3),
        Post(name: "Bekker kelly", avatar: "olivia", time: "4d", text: "Spent the afternoon volunteering at the local community center. It's always rewarding to give back.", imageName: nil, likes: 29, comments: 6, shares: 3),
        Post(name: "James Mathew", avatar: "olivia", time: "4d", text: "Spent the afternoon volunteering at the local community center. It's always rewarding to give back.", imageName: nil, likes: 29, comments: 6, shares: 3)
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            
            ScrollViewReader{ proxy in
                ScrollView {
                    
                    VStack(spacing: 0) {
                        ForEach(posts.indices, id: \.self) { index in
                            PostScreen(post:posts[index])
                                .background(
                                  index == 0 ?
                                      GeometryReader { geo in
                                        Color.clear
                                          .preference(key: ScrollOffsetPreferenceKey.self,
                                                      value: geo.frame(in: .named("scroll")).minY)
                                  }
                                   : nil
                              )
                              .padding(.bottom, 20)
                        }
                    }
                    .padding(.top, 80)
                }
                .coordinateSpace(name:"scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self){ newValue in
                    let delta = newValue - lastoffset
                    if abs(delta) > 1 {
                        withAnimation{
                            // hides the header if delta value is less then 0
                            hideHeader = delta < 0
                        }
                        lastoffset = newValue
                    }
                }
                
            }
            
            if !hideHeader {
                
                VStack(spacing: 4) {
                    Text("Mates")
                        .font(.custom("Helvetica-Bold", size: 30))
                        .italic()
                        .foregroundColor(.white)
                    
                    HStack(spacing: 20) {
                        Text("For you")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.customfont(.semibold, fontSize: 24))
                        
                        Spacer()
                        
                        Text("Around you")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.customfont(.semibold, fontSize: 24))
                                  
                    }
                    .foregroundColor(.gray)
            
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .padding(.bottom, 10)
                .background(Color.black.opacity(0.95))
                .transition(.move(edge: .top))
                .animation(.easeInOut(duration: 0.25), value: hideHeader)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}


struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat){
        value = nextValue()
    }
    
    
}



#Preview {
    HomeView()
}
