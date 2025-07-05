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
                        SearchView().tag(1)
                        PostView().tag(2)
                        ChatView().tag(3)
                        AccountView().tag(4)
                    }
                    .environmentObject(mainTabVM)
                    .tabViewStyle(.automatic)
                    .safeAreaInset(edge: .bottom) {
                        VStack(spacing: 0){
                            
                            Divider()
                                .background(Color.white)
                            
                            HStack{
                                TabButton(title: "", filledIcon: "house.fill", unFilledIcon: "house", isSelect: mainTabVM.selectedTabIndex == 0) {
                                    withAnimation {
                                        mainTabVM.selectedTabIndex = 0
                                    }
                                }
                                
                                TabButton(title: "",  filledIcon: "magnifyingglass",  unFilledIcon: "magnifyingglass", isSelect: mainTabVM.selectedTabIndex == 1) {
                                    withAnimation {
                                        mainTabVM.selectedTabIndex = 1
                                    }
                                }
                                
                                
                                TabButton(title: "",filledIcon: "plus.circle.fill",unFilledIcon: "plus.circle", isSelect: mainTabVM.selectedTabIndex == 2) {
                                    withAnimation {
                                        mainTabVM.selectedTabIndex = 2
                                    }
                                }
                                
                                TabButton(title: "", filledIcon: "ellipsis.message.fill", unFilledIcon: "ellipsis.message", isSelect: mainTabVM.selectedTabIndex == 3) {
                                    withAnimation {
                                        mainTabVM.selectedTabIndex = 3
                                    }
                                }
                                
                                
                                TabButton(title: "", filledIcon: "person.fill", unFilledIcon: "person", isSelect: mainTabVM.selectedTabIndex == 4) {
                                    withAnimation {
                                        mainTabVM.selectedTabIndex = 4
                                    }
                                }
                            }
                            .padding(.top, 10)
                            .background(Color.black)
                        }
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    MainView()
}
