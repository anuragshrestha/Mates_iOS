import SwiftUI

struct Post: Identifiable {
    let id = UUID()
    let name: String
    let avatar: String
    let time: String
    let text: String
    let imageName: String?
    let likes: Int
    let comments: Int
    let shares: Int
}


enum TabSelection: Hashable {
   case aroundyou, foryou
}

struct HomeView: View {
    
    @Namespace private var underline
    @State private var lastOffset: CGFloat = 0
    @State private var hideHeader: Bool = false
    @State private var selectedTab:TabSelection = .aroundyou
    
    let posts: [Post] = [
        Post(name: "Ethan Carter", avatar: "ethan", time: "1d", text: "I'm looking for a study group for my Calculus class. Anyone interested?", imageName: "math", likes: 23, comments: 5, shares: 2),
        Post(name: "Sophia Clark", avatar: "sophia", time: "2d", text: "Just finished a great workout at the campus gym! Feeling energized and ready to tackle the day.", imageName: nil, likes: 18, comments: 3, shares: 1),
        Post(name: "Ethan Harper", avatar: "ethan2", time: "2d", text: "Anyone else feel like the dining hall food has been extra bland lately? I swear, they've been skimping on the seasoning. #CollegeLife #FoodieProblems", imageName: "food", likes: 23, comments: 12, shares: 5),
        Post(name: "Olivia Bennett", avatar: "olivia", time: "4d", text: "Spent the afternoon volunteering at the local community center. It's always rewarding to give back.", imageName: nil, likes: 29, comments: 6, shares: 3),
        Post(name: "Bekker kelly", avatar: "olivia", time: "4d", text: "Spent the afternoon volunteering at the local community center. It's always rewarding to give back.", imageName: nil, likes: 29, comments: 6, shares: 3),
        Post(name: "James Mathew", avatar: "olivia", time: "4d", text: "Spent the afternoon volunteering at the local community center. It's always rewarding to give back.", imageName: nil, likes: 29, comments: 6, shares: 3)
    ]
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            
            
            TabView(selection: $selectedTab) {
                
                ScrollableTabContent (content: {AroundYouScreen(posts: posts)}, lastOffSet: $lastOffset, hideHeader: $hideHeader)
                    .tag(TabSelection.aroundyou)
                
                
                ScrollableTabContent(content: {ForYouScreen()}, lastOffSet: $lastOffset, hideHeader: $hideHeader)
                    .tag(TabSelection.foryou)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            
            
            // Header
            if !hideHeader {
                VStack(spacing: 4) {
                    Text("Mates")
                        .font(.custom("Helvetica-Bold", size: 30))
                        .italic()
                        .foregroundColor(.white)
                    
                    HStack(spacing: 20) {
                        ForEach([TabSelection.aroundyou, .foryou], id: \.self){ tab in
                            VStack(spacing: 4){
                                Text(tab == .aroundyou ? "Around you" : "For you")
                                    .font(.customfont(.semibold, fontSize: 24))
                                    .foregroundColor(selectedTab == tab ? .white : .gray)
                                    
                                    if selectedTab == tab {
                                    Capsule()
                                        .fill(Color.white)
                                        .frame(height: 2)
                                        .matchedGeometryEffect(id: "underline", in: underline)
                                }else{
                                    Capsule()
                                        .fill(Color.clear)
                                        .frame(height: 2)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .onTapGesture {
                                withAnimation(.easeInOut){
                                    selectedTab = tab
                                }
                            }
                        }
                    }

                }
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .padding(.bottom, 10)
                .background(Color.black.opacity(0.95))
                .transition(.move(edge: .top))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}


struct ScrollableTabContent<Content: View>: View {
    let content: () -> Content
    @Binding var lastOffSet: CGFloat
    @Binding var hideHeader:Bool
    
    var body: some View {
        
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    content()
                }
                .padding(.top, 80)
            }
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ScrollOffsetPreferenceKey.self,
                                    value: geometry.frame(in: .named("scroll")).minY)
                }
            )
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { newValue in
                let delta = newValue - lastOffSet
                
                // Only update if the change is significant enough
                if abs(delta) > 10 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        // Hide header when scrolling down (delta < 0)
                        // Show header when scrolling up (delta > 0)
                        hideHeader = delta < 0
                    }
                    lastOffSet = newValue
                }
            }
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        let translation = value.translation.height
                        if abs(translation) > 20 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                hideHeader = translation < 0
                            }
                        }
                    }
            )
        }
        
    }
}


struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


#Preview {
    HomeView()
}


