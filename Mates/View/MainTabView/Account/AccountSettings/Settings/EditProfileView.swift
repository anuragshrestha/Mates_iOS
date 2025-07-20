//
//  EditProfileView.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/12/25.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    
    @EnvironmentObject var userSession: UserSession
    
    @Environment(\.dismiss) var dismiss
    @State private var searchText: String = ""
    @State private var showMajorPicker: Bool = false
    @State private var showYearPicker: Bool = false
    
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    
    @State private var fullName: String = ""
    @State private var major: String = ""
    @State private var schoolYear: String = ""
    @State private var bio:String = ""
    
    @State private var majors = [String]()
    @State private var schoolYears = [String]()
    
    var body: some View {
        
        ZStack{
            Color.black.background().ignoresSafeArea()
            
            VStack{
                
                VStack {
                    if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        AsyncImage(url: URL(string: userSession.currentUser?.profileImageUrl ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    }
                    
                    // Button to trigger the PhotosPicker
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Text("Change Photo")
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.bottom, 10)
                
                
                InputField2(text: $fullName, placeholder: "Enter your full Name")
                    .padding(.bottom, 10)
                
                
                InputField2(text: $bio, placeholder: "Update your bio")
                    .padding(.bottom, 10)
                
                DropdownField(title: "Select your major", value: major) {
                    searchText = ""
                    showMajorPicker.toggle()
                }
                
                
                DropdownField(title: "Select your school year", value: schoolYear) {
                    searchText = ""
                    showYearPicker.toggle()
                }
              
                
                Button(action: {
                    //api call to update the info
                }) {
                    Text("Update")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                
                Spacer()
                
            }
            .padding(.top)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItemGroup(placement: .principal) {
                    Text("Update your info")
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .semibold))
                }
            }
            .onAppear {
                if let currentUser = userSession.currentUser {
                    fullName = currentUser.fullName
                    major = currentUser.major
                    schoolYear = currentUser.schoolYear
                    bio = currentUser.bio
                }
                
                majors = DataLoader.loadArray(from: "schoolMajors")
                schoolYears = DataLoader.loadArray(from: "schoolYears")
            }
            
            //Removes the dropdown view when user clicks outside of the screen
            if showMajorPicker || showYearPicker {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showMajorPicker = false
                        showYearPicker = false
                    }
            }
            
            if showMajorPicker {
                DropdownSelectorView(
                    title: "Major",
                    items: majors,
                    selection: $major,
                    isPresented: $showMajorPicker,
                    searchText: $searchText
                )
            }

            if showYearPicker {
                DropdownSelectorView(
                    title: "School Year",
                    items: schoolYears,
                    selection: $schoolYear,
                    isPresented: $showYearPicker,
                    searchText: $searchText
                )
            }
//            .onChange(of: selectedPhoto) { _, newItem in
//                      Task {
//                          if let data = try? await newItem?.loadTransferable(type: Data.self) {
//                              selectedImageData = data
//                          }
//                      }
//            }
            
        }
    }
    
    
}

#Preview {

    let previewSession = UserSession()
    previewSession.currentUser = UserAccountModel(
        id: UUID(),
        email: "test@example.com",
        fullName: "Anurag Shrestha",
        universityName: "Harvard University",
        major: "Computer Science",
        schoolYear: "Senior",
        createdAt: "2024-01-01T00:00:00Z",
        profileImageUrl: "https://example.com/profile.jpg",
        postCount: 5,
        followersCount: 100,
        followingCount: 80,
        bio: "Hi guys"
    )
    
    return NavigationStack {
        EditProfileView()
            .environmentObject(previewSession)
    }
}
