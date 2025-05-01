

import SwiftUI

struct GetStartedView: View {
    @State private var universities = [String]()
    @State private var majors = [String]()
    @State private var schoolYears = [String]()

    @State private var selectedUniversity = ""
    @State private var selectedMajor = ""
    @State private var selectedYear = ""

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
            
            
            VStack(spacing: 5) {
                Text("Get Started")
                    .font(.customfont(.bold, fontSize: 34))
                    .foregroundColor(.white)
                    .padding(.top, 100)
                
                Spacer().frame(height: 60)
                
                DropdownField(title: "Select your university", value: selectedUniversity) {
                    searchText = ""
                    showUniversityPicker.toggle()
                }

                DropdownField(title: "Select your major", value: selectedMajor) {
                    searchText = ""
                    showMajorPicker.toggle()
                }

                DropdownField(title: "Select your school year", value: selectedYear) {
                    searchText = ""
                    showYearPicker.toggle()
                }

            

                NavigationLink(destination: SignUpView(), isActive: $pressedSignUp) {
                    EmptyView()
                }

                CustomButton(title: "Next", color: .white) {
                    
                    if selectedUniversity.isEmpty {
                        showAlert = true
                        alertMessage = "Select your university"
                    }else if selectedMajor.isEmpty {
                        showAlert = true
                        alertMessage = "Select your major"
                    }else if selectedYear.isEmpty {
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
                
                Spacer()
                
                HStack{
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
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
           

            if showUniversityPicker {
                DropdownSelectorView(title: "University", items: universities, selection: $selectedUniversity, isPresented: $showUniversityPicker, searchText: $searchText)
            }

            if showMajorPicker {
                DropdownSelectorView(title: "Major", items: majors, selection: $selectedMajor, isPresented: $showMajorPicker, searchText: $searchText)
            }

            if showYearPicker {
                DropdownSelectorView(title: "School Year", items: schoolYears, selection: $selectedYear, isPresented: $showYearPicker, searchText: $searchText)
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
    
    NavigationView{
        GetStartedView()
    }
}

