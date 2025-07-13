//
//  EditProfileView.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/12/25.
//

import SwiftUI

struct EditProfileView: View {
    
   @Binding var user: UserAccountModel
  
    @State private var searchText: String = ""
    @State private var showMajorPicker: Bool = false
    @State private var showYearPicker: Bool = false
    
   
    
    var body: some View {
       
        ZStack{
            Color.black.background().ignoresSafeArea()
            
            VStack{
                
                InputField(text: $user.fullName, placeholder: "Enter your full Name")
                    .padding(.bottom, 10)
                
                DropdownField(title: "Select your major", value: user.major) {
                    searchText = ""
                    showMajorPicker.toggle()
                }
                
                DropdownField(title: "Select your school year", value: user.schoolYear) {
                    searchText = ""
                    showYearPicker.toggle()
                }
                
            }
        }
    }
}




#Preview {

    struct PreviewWrapper: View {
    
        @State var user = UserAccountModel(
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
            followingCount: 80
        )

        var body: some View {
            EditProfileView(user: $user)
        }
    }

    return PreviewWrapper()
}
