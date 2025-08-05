//
//  PostService.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/1/25.
//

import Foundation
import UIKit
import UniformTypeIdentifiers


struct PostRequest{
  let status:String
  let media: [MediaItems]
}


struct PostResponse {
    let success: Bool
    let message: String?
    let error: String?
}


extension URL {
    func mimeType() -> String? {
        guard let uti = UTType(filenameExtension: pathExtension) else { return nil }
        return uti.preferredMIMEType
    }
}

class PostService {
    
    static let shared = PostService()
    private init(){}
    
    func createPost(request: PostRequest, completion: @escaping (Bool, String?) -> Void){
        
        //check if its a valid url string
        guard let url = URL(string:"\(Config.baseURL)/posts") else {
            completion(false, "Invalid URL")
            return
        }
        
        
        //Initializes the request with the url
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        
        //creates a unique boundary string
        let boundary = UUID().uuidString
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        /**
         - start a new body part for status
         - converts the string to Data object using .utf8 which is a standard encoding used for hTTP requests.
        **/
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"status\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(request.status)\r\n".data(using: .utf8)!)
        
        
        
        //add the media files
        for (index, media) in request.media.enumerated() {
              if media.type == .image {
                  // Use the stored data instead of re-compressing
                  if let imageData = media.data {
                      body.append("--\(boundary)\r\n".data(using: .utf8)!)
                      body.append("Content-Disposition: form-data; name=\"media\"; filename=\"media_\(index).jpg\"\r\n".data(using: .utf8)!)
                      body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                      body.append(imageData)
                      body.append("\r\n".data(using: .utf8)!)
                  }
              } else if media.type == .video {
                  // Use the stored data for video
                  if let videoData = media.data {
                      let mimeType = media.url?.mimeType() ?? "video/mp4"
                      let fileExtension = media.url?.pathExtension.lowercased() ?? "mp4"
                      
                      body.append("--\(boundary)\r\n".data(using: .utf8)!)
                      body.append("Content-Disposition: form-data; name=\"media\"; filename=\"media_\(index).\(fileExtension)\"\r\n".data(using: .utf8)!)
                      body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
                      body.append(videoData)
                      body.append("\r\n".data(using: .utf8)!)
                  }
              }
          }
        
        
        //closes the body boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        urlRequest.httpBody = body
        
     
        
        if let token = KeychainHelper.loadAccessToken() {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("token: ", token)
            
        }else{
            print("no access token found")
        }
        
        // Set timeout for large uploads
        urlRequest.timeoutInterval = 300
        
        // Create URLSession with custom configuration for large uploads
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 600
        let session = URLSession(configuration: configuration)
        
    
        
        //sends the URL request to the backend
        session.dataTask(with: urlRequest) { data, response, error in
            
            
            //checks if there is a network error
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            
            //Checks if its Invalid HTTP response
            guard let htttpResponse = response as? HTTPURLResponse else{
                completion(false, "Not a HTTP response")
                return
            }
            
            
            //checks if the response is success
            if htttpResponse.statusCode == 200 {
                completion(true, "Successfully created post")
            }else{
                let errorMessage = data.flatMap{ String(data: $0, encoding: .utf8)} ?? "Uknow Server error"
                completion(false, errorMessage)
            }
        }.resume()
    }
}
