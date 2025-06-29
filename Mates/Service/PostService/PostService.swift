//
//  PostService.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/1/25.
//

import Foundation
import UIKit


struct PostRequest{
  let status:String
  let image : UIImage?
}


struct PostResponse {
    let success: Bool
    let message: String?
    let error: String?
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
        
        
        //checks if there is a image
        if let image = request.image,
           let imageData = image.jpegData(compressionQuality: 1.0) {
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"post.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
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
        
    
        
        //sends the URL request to the backend
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            
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
            if htttpResponse.statusCode == 201, let data = data {
                if let json = try?  JSONSerialization.jsonObject(with: data) as? [String:Any],
                   let postId = json["postId"] as? String {
                    completion(true, "Post Created with id: \(postId)")
                }
            }else{
                let errorMessage = data.flatMap{ String(data: $0, encoding: .utf8)} ?? "Uknow Server error"
                completion(false, errorMessage)
            }
        }.resume()
    }
}
