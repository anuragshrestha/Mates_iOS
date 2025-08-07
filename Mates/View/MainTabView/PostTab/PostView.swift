//
//  PostView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//

import SwiftUI
import PhotosUI
import AVKit

struct PostView: View {
    
    
    @EnvironmentObject var mainTabVM: MainTabViewModel
    @EnvironmentObject var postVM: PostViewModel
    @State var cancelPost:Bool = false
    @Environment(\.dismiss) private var dismiss
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State private var navigateToHome:Bool = false

    
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
                            postVM.postText = ""
                            postVM.selectedItem = []
                            postVM.selectedMedia = []
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
                            
                            if postVM.postText.isEmpty {
                               showAlert = true
                                alertMessage = "Please enter text to post"
                                return
                            }
                            
                            
                            postVM.submitPost() { success, message in
                                print("success: ", success)
                                DispatchQueue.main.async {
                                    if success {
                                        showAlert = true
                                        alertMessage = "Successfully uploaded post"
                                        postVM.postText = ""
                                        postVM.selectedItem = []
                                        postVM.selectedMedia = []
                                    }else{
                                        showAlert = true
                                        alertMessage = "Failed to upload post. \n Try again"
                                    }
                                }
                                
                            }
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
                
             
                //shows the selected media
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack{
                        ForEach(postVM.selectedMedia, id: \.id) { media in
                            ZStack(alignment: .topTrailing) {
                                if media.type == .image, let image = media.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(12)
                                        .padding(.horizontal, 4)
                                }else if media.type == .video {
                                    ZStack{
                                        if let thumbnail = media.thumbnail {
                                            Image(uiImage: thumbnail)
                                                .resizable()
                                                .frame(width: 100, height: 100)
                                                .cornerRadius(12)
                                                .padding(.horizontal, 4)
                                        }else{
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.3))
                                                .frame(width: 100, height: 100)
                                        }
                                        
                                        Image(systemName: "play.circle.fill")
                                         .font(.system(size: 40))
                                         .foregroundColor(.white)
                                         .shadow(radius: 4)
                                     
                                    }
                                    .cornerRadius(12)
                                }
                                
                                Button(action: {
                                    postVM.removeMedia(media)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .background(Circle().fill(Color.black.opacity(0.6)))
                                }
                                .padding(4)
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    .padding()
                }
                .padding(.top, 20)
                
                
                HStack {
                    PhotosPicker(selection: $postVM.selectedItem, maxSelectionCount: 10, matching: .any(of: [.images, .videos]), photoLibrary: .shared()){
                        VStack(alignment: .leading){
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 24))
                                .padding(10)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                        
                            
                            Text("Add media")
                                .font(.customfont(.semibold, fontSize: 22))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                    }
                    .disabled(postVM.isLoading)
                    
                    Spacer()
                }
                .padding(.top, 20)
      
     
               Spacer()
                
            }
            
            
            //shows progress view until we get response from backend
            if postVM.isLoading{
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .blur(radius: 4)
                    .transition(.opacity)
                
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2.0)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(12)
                
            }
         }
        .alert("", isPresented: $showAlert){
            Button("Ok"){
                if alertMessage == "Successfully uploaded post"{
                    navigateToHome = true
                }
            }
        }message: {
            Text(alertMessage)
        }
        .onChange(of: postVM.selectedItem) { newItems in
            Task{
                await postVM.loadMedia(from: newItems)
            }
        }
        .onChange(of: navigateToHome) { newValue in
            if newValue{
                mainTabVM.selectedTabIndex = 0
                navigateToHome = false
            }
        }
     }
}

#Preview {
    
    NavigationStack {
        PostView()
            .environmentObject(MainTabViewModel())
        
    }
}
