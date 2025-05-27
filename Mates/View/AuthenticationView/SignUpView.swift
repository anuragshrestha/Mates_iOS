
//
//  SignUpView.swift
//  Mates
//
//  Created by Anurag Shrestha on 4/17/25.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var signUpVM = SignupViewModel()
    @State var signUp:Bool = false
    @State var alertMessage:String = ""
    @State var showAlert:Bool = false

    
    
    
    var body: some View {
        

            ZStack{
                
                Color.black.ignoresSafeArea()
                
                ScrollView{
                    VStack{
                        
                        if signUpVM.selectedItem == nil{
                            PhotosPicker(selection: $signUpVM.selectedItem, matching: .images, photoLibrary: .shared()) {
                                VStack{
                                    Image(systemName: "photo.badge.plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 120, height: 120)
                                        .foregroundColor(.gray.opacity(0.8))
                                        .background(Color.white.opacity(0.1))
                                        .clipShape(Circle())
                                    
                                    Text("Upload Profile Image")
                                        .font(.customfont(.bold, fontSize: 24))
                                        .foregroundColor(.white)
                                }
                                .padding(.bottom, 10)
                            }
                        }else{
                            if let image = signUpVM.selectedImage{
                                PhotosPicker(selection: $signUpVM.selectedItem,matching: .images, photoLibrary: .shared()) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 120, height: 120)
                                        .shadow(radius: 4)
                                        .overlay(
                                            Circle().stroke(Color.white.opacity(0.3), lineWidth: 2)
                                        )
                                        .padding(.top, 10)
                                    
                                }
                            }
                        }
                        
                        
                        InputField(text: $signUpVM.email, placeholder: "Enter your school email")
                            .padding(.vertical, 10)
                        
                        InputField(text: $signUpVM.firstName, placeholder: "Enter your first name")
                            .padding(.vertical, 10)
                        
                        InputField(text: $signUpVM.lastName, placeholder: "Enter your last name")
                            .padding(.vertical, 10)
                        
                        SecureTextField(password: $signUpVM.password, placeholder: "Enter your password", isSecure: $signUpVM.isSecure)
                            .padding(.vertical, 10)
                        
                        
                        HStack {
                            Text("By continuing you agree to our ")
                                .font(.customfont(.semibold, fontSize: 20))
                                .foregroundColor(.white) +
                            Text("terms of Service ")
                                .font(.customfont(.semibold, fontSize: 20))
                                .foregroundColor(.blue) +
                            Text("and ")
                                .font(.customfont(.semibold, fontSize: 20))
                                .foregroundColor(.white) +
                            Text("Privacy Policy.")
                                .font(.customfont(.semibold, fontSize: 20))
                                .foregroundColor(.blue)
                        }
                        .padding(.bottom, 10)
                        .padding(.horizontal,12)
                        
                        CustomButton(title: "Sign up",color: .blue) {
                            
                            
                            //checks if any of the Input field is empty
                            
                            if signUpVM.selectedImage == nil{
                                alertMessage = "Please upload a picture"
                                showAlert = true
                            }else if signUpVM.email.isEmpty{
                                showAlert = true
                                alertMessage = "Enter your school email"
                            }else if signUpVM.firstName.isEmpty {
                                showAlert = true
                                alertMessage = "Enter your first name"
                            }else if signUpVM.lastName.isEmpty {
                                showAlert = true
                                alertMessage = "Enter your last name"
                            }else if signUpVM.password.isEmpty {
                                showAlert = true
                                alertMessage = "Enter your password"
                            } else if !signUpVM.isValidEmail(_email: signUpVM.email) {
                                showAlert = true
                                alertMessage = "Enter a valid school email"
                            } else if !signUpVM.isValidPassword(signUpVM.password){
                                showAlert = true
                                alertMessage = "Password must be at least 6 characters and have \n one upper, lower, digit and special character"
                            } else if signUpVM.universityName.isEmpty {
                                showAlert = true
                                alertMessage = "Select your university"
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    dismiss()
                                }
                            }else if signUpVM.major.isEmpty {
                                showAlert = true
                                alertMessage = "Select your major"
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                    dismiss()
                                }
                            }else if signUpVM.schoolYear.isEmpty {
                                showAlert = true
                                alertMessage = "Select your school year"
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                    dismiss()
                                }
                            }else{
                                signUpVM.signUp { success, message in
                                    if success{
                                        signUp = true
                                    }else{
                                        
                                        guard let message = message?.lowercased() else {
                                            alertMessage = "An error occured. \n Please try again."
                                            showAlert = true
                                            return
                                        }
                                        
                                        if message.contains("email already registered") || message.contains("Account already created"){
                                            alertMessage = "Email already registered. \n Please sign in."
                                            showAlert = true
                                        } else{
                                            alertMessage  = message
                                            showAlert = true
                                        }
                                    }
                                }
                            }
                        }
                        .alert("Missing Info", isPresented: $showAlert){
                            Button("Ok", role: .cancel) {}
                        } message: {
                            Text(alertMessage)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                        
                    }
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
                ConfirmView(email: signUpVM.email)
            }
            .onChange(of: signUpVM.selectedItem) { newItem in
                Task{
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data){
                        signUpVM.selectedImage = uiImage
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
