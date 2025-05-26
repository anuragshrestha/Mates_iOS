

import SwiftUI

struct GetStartedView: View {
    
    @StateObject var signUpVM = SignupViewModel()
    
    
    @State private var universities = [String]()
    @State private var majors = [String]()
    @State private var schoolYears = [String]()

    @State private var showUniversityPicker = false
    @State private var showMajorPicker = false
    @State private var showYearPicker = false

    @State private var searchText = ""
    @State private var pressedSignUp = false
    
    @State var showAlert:Bool = false
    @State var alertMessage:String = ""

    var body: some View {
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            ScrollView{
                VStack(spacing: 5) {
                    Text("Get Started")
                        .font(.customfont(.bold, fontSize: 34))
                        .foregroundColor(.white)
                        .padding(.top, 100)
                    
                    Spacer().frame(height: 60)
                    
                    DropdownField(title: "Select your university", value: signUpVM.universityName) {
                        searchText = ""
                        showUniversityPicker.toggle()
                    }
                    
                    DropdownField(title: "Select your major", value: signUpVM.major) {
                        searchText = ""
                        showMajorPicker.toggle()
                    }
                    
                    DropdownField(title: "Select your school year", value: signUpVM.schoolYear) {
                        searchText = ""
                        showYearPicker.toggle()
                    }
                    
                    
                                        
                    CustomButton(title: "Next", color: .blue) {
                        
                        if signUpVM.universityName.isEmpty {
                            showAlert = true
                            alertMessage = "Select your university"
                        }else if signUpVM.major.isEmpty {
                            showAlert = true
                            alertMessage = "Select your major"
                        }else if signUpVM.schoolYear.isEmpty {
                            showAlert = true
                            alertMessage = "Select your school year"
                        }else{
                            pressedSignUp = true
                        }
                    }
                    .alert("Missing Details", isPresented: $showAlert){
                        Button("Ok", role: .cancel){}
                    } message: {
                        Text(alertMessage)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .navigationDestination(isPresented: $pressedSignUp) {
                    SignUpView(signUpVM: signUpVM)
                }
            }
            
            VStack{
                Spacer()
                
                HStack {
                      Text("Already have an account?")
                          .font(.customfont(.semibold, fontSize: 22))
                          .foregroundColor(.white)

                      NavigationLink(destination: SignInView()) {
                          Text("Sign In")
                              .font(.customfont(.semibold, fontSize: 22))
                      }
                }
                .padding(.bottom, 50)
            }

            if showUniversityPicker {
                DropdownSelectorView(title: "University", items: universities, selection: $signUpVM.universityName, isPresented: $showUniversityPicker, searchText: $searchText)
            }

            if showMajorPicker {
                DropdownSelectorView(title: "Major", items: majors, selection: $signUpVM.major, isPresented: $showMajorPicker, searchText: $searchText)
            }

            if showYearPicker {
                DropdownSelectorView(title: "School Year", items: schoolYears, selection: $signUpVM.schoolYear, isPresented: $showYearPicker, searchText: $searchText)
            }
            
        }
        .background(Color.black.opacity(showUniversityPicker || showMajorPicker || showYearPicker ? 0.4 : 1.0)
            .ignoresSafeArea()
            .onTapGesture {
                showUniversityPicker = false
                showMajorPicker = false
                showYearPicker = false
            })
        .onAppear {
            universities = DataLoader.loadUniversityNames()
            majors = DataLoader.loadArray(from: "schoolMajors")
            schoolYears = DataLoader.loadArray(from: "schoolYears")
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}


#Preview {
    
    NavigationStack{
        GetStartedView()
    }
}

