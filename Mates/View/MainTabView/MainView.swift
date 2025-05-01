//
//  MainView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var mainTabVM = MainTabViewModel()
    
    var body: some View {
        
        ZStack{
            
            Color.black.ignoresSafeArea()
            
            VStack {
                TabView(selection: $mainTabVM.selectedTabIndex) {
                    HomeView().tag(0)
                    PostView().tag(1)
                    ChatView().tag(2)
                    ProfileView().tag(3)
                }
                .tabViewStyle(.automatic)
                
                VStack(spacing: 0){
                    
                    Divider()
                        .background(Color.white)
                    
                    HStack{
                        TabButton(title: "Home", filledIcon: "house.fill", unFilledIcon: "house", isSelect: mainTabVM.selectedTabIndex == 0) {
                            withAnimation {
                                mainTabVM.selectedTabIndex = 0
                            }
                        }
                        
                        TabButton(title: "Post",filledIcon: "plus.circle.fill",unFilledIcon: "plus.circle", isSelect: mainTabVM.selectedTabIndex == 1) {
                            withAnimation {
                                mainTabVM.selectedTabIndex = 1
                            }
                        }
                        
                        TabButton(title: "Chat", filledIcon: "message.fill", unFilledIcon: "message", isSelect: mainTabVM.selectedTabIndex == 2) {
                            withAnimation {
                                mainTabVM.selectedTabIndex = 2
                            }
                        }
                        
                        TabButton(title: "Profile", filledIcon: "person.crop.circle.fill", unFilledIcon: "person.crop.circle", isSelect: mainTabVM.selectedTabIndex == 3) {
                            withAnimation {
                                mainTabVM.selectedTabIndex = 3
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    .padding(.top, 10)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    MainView()
}
