//
//  PostViewModel.swift
//  Mates
//
//  Created by Anurag Shrestha on 5/26/25.
//

import Foundation
import PhotosUI
import SwiftUI
import AVFoundation


struct MediaItems: Identifiable {
    let id = UUID()
    let type: MediaType
    let image: UIImage?
    let url: URL?
    let thumbnail: UIImage?
    let data: Data?
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
    
    
      // Clean up temporary files when deinitialized
       deinit {
           cleanupTemporaryFiles()
       }
    
    
    func loadMedia(from items: [PhotosPickerItem]) async {
        
            // Process items concurrently and collect results
            let mediaItems = await withTaskGroup(of: MediaItems?.self) { group in
                for item in items {
                    group.addTask {
                        await self.processMediaItem(item)
                    }
                }
                
                var results: [MediaItems] = []
                for await mediaItem in group {
                    if let mediaItem = mediaItem {
                        results.append(mediaItem)
                    }
                }
                return results
            }
            
            await MainActor.run {
                self.selectedMedia = mediaItems
            }
        }
        
    
    
        private func processMediaItem(_ item: PhotosPickerItem) async -> MediaItems? {
            do {
                if let data = try await item.loadTransferable(type: Data.self) {
                    if item.supportedContentTypes.first(where: { $0.conforms(to: .image) }) != nil {
                        // Handle image
                        if let uiImage = UIImage(data: data) {
                            // Compress image to reduce size
                            let compressedData = uiImage.jpegData(compressionQuality: 0.8) ?? data
                            return MediaItems(
                                type: .image,
                                image: uiImage,
                                url: nil,
                                thumbnail: nil,
                                data: compressedData
                            )
                        }
                    } else if item.supportedContentTypes.first(where: { $0.conforms(to: .movie) }) != nil {
                      
                        // Handle video
                        let tempURL = FileManager.default.temporaryDirectory
                            .appendingPathComponent(UUID().uuidString)
                            .appendingPathExtension("mov")
                        
                        try data.write(to: tempURL)
                        
                        // Generate thumbnail
                        let thumbnail = await generateThumbnail(from: tempURL)
                        
                        return MediaItems(
                            type: .video,
                            image: nil,
                            url: tempURL,
                            thumbnail: thumbnail,
                            data: data
                        )
                    }
                }
            } catch {
                print("Error loading media item: \(error)")
            }
            return nil
        }
    
    
    
    
    
    func generateThumbnail(from url: URL) async -> UIImage? {
            return await withCheckedContinuation { continuation in
                DispatchQueue.global().async {
                    let asset = AVAsset(url: url)
                    let imageGenerator = AVAssetImageGenerator(asset: asset)
                    imageGenerator.appliesPreferredTrackTransform = true
                    
                    let time = CMTime(seconds: 1, preferredTimescale: 60)
                    
                    do {
                        let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                        let thumbnail = UIImage(cgImage: cgImage)
                        continuation.resume(returning: thumbnail)
                    } catch {
                        print("Error generating thumbnail: \(error)")
                        continuation.resume(returning: nil)
                    }
                }
            }
        }
        
    
    
        func removeMedia(_ media: MediaItems) {
            selectedMedia.removeAll { $0.id == media.id }
            
            // Cleans up temporary file if it's a video
            if media.type == .video, let url = media.url {
                try? FileManager.default.removeItem(at: url)
            }
        }
    
    
        
        func cleanupTemporaryFiles() {
            for media in selectedMedia {
                if media.type == .video, let url = media.url {
                    try? FileManager.default.removeItem(at: url)
                }
            }
        }
    
    
    
    //creates a new post
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
    
    
    //updates the status of the post with the post_id
    func updatePost(post_id: String, status: String, completion: @escaping(Bool, String?) -> Void) {
        
        isLoading = true
        
        let request = PostUpdateRequest(post_id: post_id, status: status)
        
        PostService.shared.updatePost(request: request) { success, message in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if success {
                    print("Successfully updated post \(String(describing: message))")
                }else{
                    print("Failed to update post \(String(describing: message))")
                }
            }
            
            completion(success, message)
        }
    }
    
    
    
    //calls the delete post service to delete the post: post_id
    func deletePost(post_id: String, completion: @escaping (Bool, String?) -> Void) {
        
        isLoading = true
        
        let request = PostDeleteRequest(post_id: post_id)
        
        PostService.shared.deletePost(request: request) { success, message in
            DispatchQueue.main.async {
                self.isLoading = false
                if success {
                    print("Successfully deleted post \(String(describing: message))")
                }else{
                    print("Failed to delete post \(String(describing: message))")
                }
            }
            
            completion(success, message)
            
        }
    }
    

}
