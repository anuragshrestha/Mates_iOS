//import SwiftUI
//
//struct GetStartedView: View {
//
//    @State private var universities:[String] = []
//    @State private var major: [String] = []
//    @State private var schoolYear:[String] = []
//
//    @State private var selectedUniversity: String = ""
//    @State private var selectedMajor: String = ""
//    @State private var selectedYear: String = ""
//
//    @State private var showUniversityPicker:Bool = false
//    @State private var showMajorPicker:Bool = false
//    @State private var showSchoolYear: Bool = false
//
//    @State private var searchText: String = ""
//    @State private var pressedSignUp: Bool = false
//
//
//    var body: some View {
//        ZStack(alignment: .top) {
//            VStack {
//                Text("Get Started")
//                    .font(.customfont(.bold, fontSize: 34))
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.center)
//                    .padding(.top, 20)
//
//                Spacer().frame(height: 70)
//
//                VStack {
//                    DropdownField(title: "Select your university", value: selectedUniversity) {
//                        searchText = ""
//                        showUniversityPicker.toggle()
//                    }
//                    
//                    DropdownField(title: "Select your major", value: selectedMajor) {
//                        searchText = ""
//                        showMajorPicker.toggle()
//                    }
//                    
//                    DropdownField(title: "Select your school year", value: selectedYear) {
//                        searchText = ""
//                        showSchoolYear.toggle()
//                    }
//                    
//                    
//                    Spacer().frame(height: 50)
//
//                    NavigationLink(destination: SignUpView(), isActive: $pressedSignUp) {
//                        EmptyView()
//                    }
//
//                    CustomButton(title: "Next", color: .white) {
//                        pressedSignUp = true
//                    }
//                }
//            }
//            .padding()
//            
//                if showUniversityPicker{
//                    dropDownLayer(
//                        title: "Select your university",
//                        list: universities,
//                        selected: $selectedUniversity,
//                        showPicker: $showUniversityPicker
//                    )
//                }
//                
//                if showMajorPicker{
//                    dropDownLayer(
//                        title: "Select your major",
//                        list: major,
//                        selected: $selectedMajor,
//                        showPicker: $showMajorPicker
//                    )
//                }
//                
//                if showSchoolYear{
//                    dropDownLayer(
//                        title: "Select your school year",
//                        list: schoolYear,
//                        selected: $selectedYear,
//                        showPicker: $showSchoolYear
//                    )
//                }
//            }
//            .background(
//                Color.black.opacity(showUniversityPicker || showMajorPicker || showSchoolYear ? 0.4 : 1.0)
//                    .ignoresSafeArea()
//                    .onTapGesture {
//                        showUniversityPicker = false
//                        showMajorPicker = false
//                        showSchoolYear = false
//                    })
//            .ignoresSafeArea()
//            .navigationBarHidden(true)
//            .onAppear {
//                loadUniversityNames()
//                loadData()
//            }
//        }
//
//        func dropDownLayer(title: String, list: [String], selected:Binding<String> , showPicker: Binding<Bool>) -> some View{
//            VStack(spacing: 40) {
//                TextField("" ,
//                          text: $searchText,
//                          prompt: Text(title)
//                                    .foregroundColor(.black)
//                )
//                .padding()
//                .background(Color.white)
//                .foregroundColor(.black)
//                .cornerRadius(8)
//                .padding(.horizontal)
//                .textFieldStyle(PlainTextFieldStyle())
//                .frame(alignment: .leading)
//
//                ScrollView {
//                    LazyVStack(alignment: .leading, spacing: 0) {
//                        
//                        let filtered = searchText.isEmpty
//                        ? Array(list.prefix(60))
//                        : list.filter { $0.localizedCaseInsensitiveContains(searchText) }
//                        
//                        ForEach(Array(filtered.enumerated()), id: \.offset) { index, item in
//                            Button(action: {
//                                selected.wrappedValue = item
//                                showPicker.wrappedValue = false
//                            }) {
//                                Text(item)
//                                    .foregroundColor(.black)
//                                    .padding(.vertical, 10)
//                                    .padding(.horizontal)
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                            }
//                            Divider()
//                        }
//                    }
//                }
//            }
//            .frame(maxHeight: .infinity, alignment: .top)
//            .background(Color.white)
//            .cornerRadius(10)
//            .padding(.horizontal)
//            .padding(.top, 140)
//            .shadow(radius: 10)
//            .transition(.move(edge: .top))
//            .zIndex(1)
//        }
//
//
//    func loadUniversityNames() {
//        guard let url = Bundle.main.url(forResource: "universities", withExtension: "json"),
//              let data = try? Data(contentsOf: url),
//              let jsonData = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
//            print("Failed to load the universities name.")
//            return
//        }
//
//        let names = jsonData.compactMap { $0["name"] as? String }
//        universities = names
//    }
//    
//    func loadData(){
//        major = loadJsonArray(filename: "schoolMajors")
//        schoolYear = loadJsonArray(filename: "schoolYears")
//    }
//    
//    func loadJsonArray(filename:String) -> [String] {
//        guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
//              let data = try? Data(contentsOf: url),
//              let array = try? JSONSerialization.jsonObject(with: data) as? [String] else{
//            print("failed to load the json file \(filename)")
//            
//            return []
//        }
//        
//        return array
//    }
//    
//}
//
//#Preview {
//    NavigationView {
//        GetStartedView()
//    }
//}
//



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

    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                Text("Get Started")
                    .font(.customfont(.bold, fontSize: 34))
                    .foregroundColor(.white)

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

                Spacer().frame(height: 50)

                NavigationLink(destination: SignUpView(), isActive: $pressedSignUp) {
                    EmptyView()
                }

                CustomButton(title: "Next", color: .white) {
                    pressedSignUp = true
                }
            }
            .padding()

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
