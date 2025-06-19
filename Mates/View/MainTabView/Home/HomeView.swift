import SwiftUI



enum TabSelection: Hashable {
   case aroundyou, foryou
}

struct HomeView: View {
    
    @ObservedObject var aroundVM = AroundYouServiceViewModel()
    @Namespace private var underline
    @State private var lastOffset: CGFloat = 0
    @State private var hideHeader: Bool = false
    @State private var selectedTab:TabSelection = .aroundyou
    

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()
            
            if aroundVM.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
            }else{
                TabView(selection: $selectedTab) {
                    
                    ScrollableTabContent (content: {AroundYouScreen(posts: aroundVM.posts)}, lastOffSet: $lastOffset, hideHeader: $hideHeader)
                        .tag(TabSelection.aroundyou)
                    
                    
                    ScrollableTabContent(content: {ForYouScreen()}, lastOffSet: $lastOffset, hideHeader: $hideHeader)
                        .tag(TabSelection.foryou)
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            

            
            
            
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
        .task{
            await aroundVM.laodAroundYouFeed()
        }
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
                .padding(.top, 100)
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


