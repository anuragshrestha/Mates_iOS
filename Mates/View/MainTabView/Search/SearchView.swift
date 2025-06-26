////
////  SeacrhView.swift
////  Mates
////
////  Created by Anurag Shrestha on 5/24/25.
////
//

import SwiftUI

struct SearchView: View {
    
    @State private var query:String = ""
    @State private var isLoading:Bool = false
    @State private var showResults:Bool = false
    @State private var users:[UserModel] = []
    
    
    
    var body: some View {
     
        VStack{
            
            TextField("Search people using name or university", text: $query)
                .padding(22)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding()
            
            if isLoading{
                VStack{
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.5)
                        .padding(.top, 100)
                    
                    Text("Searching user")
                        .foregroundColor(.white)
                }
                .frame(maxHeight: .infinity)
            }else if showResults{
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text("Top Matches")
                        .font(.headline)
                        .padding(.leading)
                        .foregroundColor(.white)
                    
                    ScrollView {
                        ForEach(users) { user in
                            HStack(spacing: 15){
                                if !user.profileImageUrl.isEmpty,
                                   let imageUrl = URL(string: user.profileImageUrl){
                                    AsyncImage(url: imageUrl){ image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                }else{
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width:40, height: 40)
                                        .foregroundColor(.gray)
                                }
                                
                                VStack(aligment: .leading) {
                                    Text(user.fullName)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        
                                    Text(user.universityName)
                                        .fontWeight(.subheadline)
                                        .foregroundColor(.white)
    
                                }
                                
                                Spacer()
                                
                            }
                            .padding(.horizontal)
                            
                        }
                    }
                    .padding(.top)
                }
                .transition(.opacity)
            }
            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
        .onChange(of: query) { newQuery in
            if newQuery.trimmingCharacters(in: .whitespaces).isEmpty{
                users = []
                showResults = false
            }else{
                fetchResults(for: newQuery)
            }
        }
    }
    
    
    
    private func fetchResults(for query: String) {
        
        isLoading = true
        showResults = false
        
        SearchUserService.fetchUser(for: query) { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result{
                case .success(let users):
                    self.users = users
                    self.showResults = true
                
                case .failure(let error):
                    print("failed while fetching users: ", error.localizedDescription)
                }
            }
        }
    }
    
}






#Preview {
    SearchView()
}

