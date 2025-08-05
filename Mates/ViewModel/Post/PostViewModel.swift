//
//  PostViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/26/25.
//

import Foundation
import _PhotosUI_SwiftUI


struct MediaItems: Identifiable {
    let id = UUID()
    let type: MediaType
    let image: UIImage?
    let url: URL?
}

enum MediaType {
    case image
    case video
}


class PostViewModel: ObservableObject{
    
    @Published var postText:String = ""
    @Published var isLoading:Bool = false
  
    @Published var selectedItem: [PhotosPickerItem] = []
    @Published var selectedMedia: [MediaItems] = []
    
    
    func submitPost(completion: @escaping (Bool, String?) -> Void){
        
        isLoading = true
        
        let request = PostRequest(status: postText, media: selectedMedia)
        
        PostService.shared.createPost(request: request) { success, message in
            DispatchQueue.main.async {
                self.isLoading = false
                if success {
                    print("Successfully uploaded post \(String(describing: message))")
                }else{
                    print("Failed to upload post \(String(describing: message))")
                }
            }
            
            completion(success, message)
            
        }
    }
}
