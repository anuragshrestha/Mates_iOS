//
//  PostView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/30/25.
//

import SwiftUI
import PhotosUI

struct PostView: View {
    
    
    @EnvironmentObject var mainTabVM: MainTabViewModel
    @StateObject var postVM = PostViewModel()
    @State var cancelPost:Bool = false
    @Environment(\.dismiss) private var dismiss
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""
    @State private var navigateToHome:Bool = false

    
    var body: some View {
        ZStack{
            
            Color.black.opacity(0.95).ignoresSafeArea()
            
            VStack(spacing: 0){
                ZStack{
                    
                    Text("Create Post")
                        .font(.customfont(.semibold, fontSize: 26))
                        .foregroundColor(.white)
                    
                    HStack{
                        Button(action: {
                            postVM.postText = ""
                            postVM.selectedImage = nil
                            postVM.selectedItem = nil
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
                                        postVM.selectedImage = nil
                                        postVM.selectedImage = nil
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
                
                HStack{
                    if let image = postVM.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(minWidth: 120, maxWidth: 160, minHeight: 140, maxHeight: 160)
                            .padding(.horizontal, 4)
                            .padding(.top, 20)
                            .cornerRadius(14)
                         
                        
                    }
                    Spacer()
                }
                .padding()
          
                
                HStack {
                    PhotosPicker(selection: $postVM.selectedItem, matching: .images, photoLibrary: .shared()){
                        VStack(alignment: .leading){
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 24))
                                .padding(10)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                        
                            
                            Text("Add image")
                                .font(.customfont(.semibold, fontSize: 22))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                    }
                    
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
        .onChange(of: postVM.selectedItem) { newItem in
            Task{
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data){
                    postVM.selectedImage = uiImage
                }
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
