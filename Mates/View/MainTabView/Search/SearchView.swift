////
////  SeacrhView.swift
////  Mates
////
////  Created by Anurag Shrestha on 5/24/25.
////
//
//import SwiftUI
//
//struct SeacrhView: View {
//    var body: some View {
//        ZStack{
//            
//            Color.black.ignoresSafeArea()
//            
//            VStack{
//                Text("Seacrh View")
//                    .font(.customfont(.bold, fontSize: 22))
//                    .foregroundColor(.white)
//            }
//        }
//    }
//}
//
//#Preview {
//    SeacrhView()
//}


import SwiftUI



struct SearchView: View {
    @State private var query = ""
    @State private var users: [UserModel] = []
    @State private var isLoading = false
    @State private var showResults = false

    var body: some View {
        VStack {
            // Search Bar
            TextField("Search users or universities...", text: $query)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding()

            // Loader or Results
            if isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.5)
                        .padding(.top, 100)
                    Text("Searching...")
                        .foregroundColor(.gray)
                }
                .frame(maxHeight: .infinity)
            } else if showResults {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Top Matches")
                        .font(.headline)
                        .padding(.leading)
                    
                    ScrollView {
                        ForEach(users) { user in
                            HStack(spacing: 15) {
                                if  !user.profileImageUrl.isEmpty,
                                    let url = URL(string: user.profileImageUrl) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.gray)
                                }

                                VStack(alignment: .leading) {
                                    Text(user.fullName)
                                        .fontWeight(.medium)
                                    Text(user.universityName)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }

                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 5)
                }
                .transition(.opacity)
            }

            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
        .onChange(of: query) { newQuery in
            if newQuery.trimmingCharacters(in: .whitespaces).isEmpty {
                users = []
                showResults = false
            } else {
                fetchResults(for: newQuery)
            }
        }
    }

    private func fetchResults(for query: String) {
        isLoading = true
        showResults = false

        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "http://localhost:4000/search-user?query=\(encodedQuery)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            guard let data = data, error == nil else {
                return
            }

            do {
                struct APIResponse: Decodable {
                    let success: Bool
                    let names: [UserModel]
                }

                let result = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self.users = result.names
                    self.showResults = true
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}
