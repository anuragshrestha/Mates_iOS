
import SwiftUI


struct EditPostModal: View {
    
    
    @Binding var showEditModal: Bool
    @Binding var post: UserPostModel
    let postVM: PostViewModel
    
    @State var editedStatus:String = ""
    @State var showUpdateAlert: Bool = false
    @State var updateMessage: String = ""
    @State var successfullyUpdated:Bool = false
    
    
    
    var body: some View{
        
        ZStack{
            
            Color.black.ignoresSafeArea()
            
            
            VStack(spacing: 0) {
                
                HStack {
                    Button(action: {
                        showEditModal = false
                    }){
                        Text("Cancel")
                            .foregroundColor(.red)
                            .font(.system(size: 20, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    Text("Edit Post")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                    
                    Spacer()
                    
                    Button(action: {
                       updatePost()
                    
                    }){
                        Text("Save")
                            .foregroundColor(.blue)
                            .font(.system(size: 20, weight: .semibold))
                            .disabled(editedStatus.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
                .padding()
                .background(Color.black)
                
                Divider()
                    .background(Color.gray)
                    .padding(.bottom, 5)
                
                
                VStack(alignment: .leading, spacing: 1) {
                    ZStack(alignment: .topLeading){
                        
                        TextEditor(text: $editedStatus)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .semibold))
                            .scrollContentBackground(.hidden)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .frame(minHeight: 150, maxHeight: 300)
                        
                        if editedStatus.isEmpty{
                            Text("What's on your mind?")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .semibold))
                                .padding(.horizontal, 24)
                                .padding(.top, 8)
                                .allowsHitTesting(false)
                        }
                    }
                    
                    HStack{
                          Spacer()
                        
                        Text("\(editedStatus.count)/500")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(editedStatus.count > 500 ? .red : .gray)
                            .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            
            
            if postVM.isLoading{
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .blur(radius: 4)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(12)

            }
           
        }
        .onAppear {
            editedStatus = post.status
        }
        .alert("", isPresented: $showUpdateAlert) {
            Button("Ok"){
                if successfullyUpdated{
                    showEditModal = false
                }
            }
        }message: {
            Text(updateMessage)
        }
    }
    
    
    private func updatePost() {
        
        let trimmedStatus = editedStatus.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("new status is: \(trimmedStatus)")
        
        guard !trimmedStatus.isEmpty && trimmedStatus.count <= 500 else{
            updateMessage = "Post Status must be between 1 and 500 characters"
            showUpdateAlert = true
            return
        }
        
        postVM.isLoading = true
        
        postVM.updatePost(post_id: post.id, status: trimmedStatus) { success, message in
            DispatchQueue.main.async {
                if success{
                    post.status = trimmedStatus
                    updateMessage = "Successfully updated post"
                    successfullyUpdated = true
                }else{
                    updateMessage = message ?? "Failed to update the post"
                }
                postVM.isLoading = false
                showUpdateAlert = true
            }
        }
    }
    
    
}







struct EditPostModal_Previews: PreviewProvider {
    
    struct PreviewWrapper: View {
        @State var isPresented = true
        @State var samplePost1 = UserPostModel(
            id: "1251625176",
            mediaUrls: nil,
            createdAt: "2025-06-17T12:00:00Z",
            status: "Hi guys",
            likes: 23,
            comments: 12,
            hasLiked: true
        )
        
        
        var body: some View {
            EditPostModal(showEditModal: $isPresented, post: $samplePost1, postVM: PostViewModel())
        }
    }
    
    
    static var previews: some View{
        PreviewWrapper()
    }
}
