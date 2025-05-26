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
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
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
                
                HStack{
                    if let image = selectedImage {
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
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()){
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
         }
        .onChange(of: selectedItem) { newItem in
            Task{
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data){
                    selectedImage = uiImage
                }
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
