//
//  SignUpView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/17/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct SignUpView: View {

    @Environment(\.dismiss) private var dismiss
    @ObservedObject var signUpVM = SignupViewModel()
    @State var signUp: Bool = false
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    @State private var isLoading: Bool = false

    // Profile image picker
    @ViewBuilder
    private func profileImagePickerView() -> some View {
        if signUpVM.selectedItem == nil {
            PhotosPicker(selection: $signUpVM.selectedItem, matching: PHPickerFilter.any(of: [.images]), photoLibrary: .shared()) {
                VStack {
                    Image(systemName: "photo.badge.plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray.opacity(0.8))
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())

                    Text("Upload Profile Image")
                        .font(.customfont(.bold, fontSize: 24))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 10)
            }
        } else if let image = signUpVM.selectedImage {
            PhotosPicker(selection: $signUpVM.selectedItem, matching: PHPickerFilter.any(of: [.images]), photoLibrary: .shared()) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 120, height: 120)
                    .shadow(radius: 4)
                    .overlay(Circle().stroke(Color.white.opacity(0.3), lineWidth: 2))
                    .padding(.top, 10)
            }
        }
    }

    var body: some View {
        
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack {
                    profileImagePickerView()

                    InputField(text: $signUpVM.email, placeholder: "Enter your school email")
                        .padding(.vertical, 10)

                    InputField(text: $signUpVM.firstName, placeholder: "Enter your first name")
                        .padding(.vertical, 10)

                    InputField(text: $signUpVM.lastName, placeholder: "Enter your last name")
                        .padding(.vertical, 10)

                    SecureTextField(password: $signUpVM.password, placeholder: "Enter your password", isSecure: $signUpVM.isSecure)
                        .padding(.vertical, 10)

                    HStack {
                        Group {
                            Text("By continuing you agree to our ")
                                .foregroundColor(.white)
                            + Text("terms of Service ")
                                .foregroundColor(.blue)
                            + Text("and ")
                                .foregroundColor(.white)
                            + Text("Privacy Policy.")
                                .foregroundColor(.blue)
                        }
                        .font(.customfont(.semibold, fontSize: 20))
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal, 12)

                    CustomButton(title: "Sign up", color: .blue) {
                        validateAndSignUp()
                    }
                    .alert("Missing Info", isPresented: $showAlert) {
                        Button("Ok", role: .cancel) {}
                    } message: {
                        Text(alertMessage)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
            }

            if isLoading {
                Color.black.opacity(0.6).ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                }
            }
        }
        .navigationDestination(isPresented: $signUp) {
            ConfirmView(email: signUpVM.email, password: signUpVM.password)
        }
        .onChange(of: signUpVM.selectedItem) { newItem in
            Task { @MainActor in
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data),
                   let typeIdentifier = newItem?.supportedContentTypes.first?.identifier {

                    let allowedTypes = ["public.jpeg", "public.png", "public.heif", "public.jpg"]
                    let maxSize = 10 * 1024 * 1024

                    if data.count > maxSize {
                        alertMessage = "Image should be less than 10 MB."
                        showAlert = true
                        signUpVM.selectedItem = nil
                        return
                    }

                    if allowedTypes.contains(typeIdentifier) {
                        signUpVM.selectedImage = uiImage
                    } else {
                        alertMessage = "Unsupported image format. \n Please select a JPG, PNG, or HEIF image."
                        showAlert = true
                        signUpVM.selectedItem = nil
                    }
                }
            }
        }
    }

   
    private func validateAndSignUp() {
        if signUpVM.selectedImage == nil {
            alertMessage = "Please upload a picture"
            showAlert = true
        } else if signUpVM.email.isEmpty {
            alertMessage = "Enter your school email"
            showAlert = true
        } else if signUpVM.firstName.isEmpty {
            alertMessage = "Enter your first name"
            showAlert = true
        } else if signUpVM.lastName.isEmpty {
            alertMessage = "Enter your last name"
            showAlert = true
        } else if signUpVM.password.isEmpty {
            alertMessage = "Enter your password"
            showAlert = true
//        } else if !signUpVM.isValidPassword(signUpVM.password) {
//            alertMessage = "Password must be at least 6 characters and have \n one upper, lower, digit and special character"
//            showAlert = true
        } else if signUpVM.universityName.isEmpty {
            alertMessage = "Select your university"
            showAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                dismiss()
            }
        } else if signUpVM.major.isEmpty {
            alertMessage = "Select your major"
            showAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                dismiss()
            }
        } else if signUpVM.schoolYear.isEmpty {
            alertMessage = "Select your school year"
            showAlert = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                dismiss()
            }
        } else {
            isLoading = true
            signUpVM.signUp { success, message in
                isLoading = false
                if success {
                    signUp = true
                } else {
                    guard let message = message?.lowercased() else {
                        alertMessage = "An error occurred. \n Please try again."
                        showAlert = true
                        return
                    }

                    if message.contains("email already registered") || message.contains("account already created") {
                        alertMessage = "Email already registered. \n Please sign in."
                    } else {
                        alertMessage = message
                    }
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}
