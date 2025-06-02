//
//  PostViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/26/25.
//

import Foundation
import _PhotosUI_SwiftUI

class PostViewModel: ObservableObject{
    
    @Published var postText:String = ""
    @Published var isLoading:Bool = false
    @Published var uploadPost:Bool = false
    
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedImage: UIImage? = nil
    
    
    func submitPost(completion: @escaping (Bool, String?) -> Void){
        
        isLoading = true
        
        let request = PostRequest(status: postText, image: selectedImage)
        
        PostService.shared.createPost(request: request) { success, message in
            DispatchQueue.main.async {
                self.isLoading = false
                if success {
                    self.uploadPost = true
                    print("Successfully uploaded post \(String(describing: message))")
                }else{
                    print("Failed to upload post \(String(describing: message))")
                }
            }
            
            
            
        }
    }
}
