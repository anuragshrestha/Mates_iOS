//
//  PostView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//

import SwiftUI

struct PostView: View {
    
    
    @EnvironmentObject var mainTabVM: MainTabViewModel
    @StateObject var postVM = PostViewModel()
    @State var cancelPost:Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack{
            
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0){
                ZStack{
                    
                    Text("Create Post")
                        .font(.customfont(.semibold, fontSize: 26))
                        .foregroundColor(.white)
                    
                    HStack{
                        Button(action: {
                            mainTabVM.selectedTabIndex = 0
                        }){
                            Image(systemName: "xmark")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .padding(.horizontal, 2)
                        }
                        
                        Spacer()
                   
                        Button(action: {
                            print("prressed post text")
                        }) {
                            Text("Post")
                                .foregroundColor(.white)
                                .font(.customfont(.semibold, fontSize: 22))
                        }
                    }
                    .padding()
                    
                }
                .padding(.top,4)
                .background(Color.black)
                .padding(.bottom, 10)
                
                
                PostField(text: $postVM.postText, placeholder: "What's on your mind?")
                
                
                Spacer()
                
    
            }
         }
//        .navigationDestination(isPresented: $cancelPost) {
//            HomeView()
//        }
     }
}

#Preview {
    
    NavigationStack {
        PostView()
            .environmentObject(MainTabViewModel())
        
    }
}
