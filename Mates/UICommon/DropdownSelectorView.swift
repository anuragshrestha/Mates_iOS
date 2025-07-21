import SwiftUI

struct DropdownSelectorView: View {
    let title: String
    let items: [String]
    @Binding var selection: String
    @Binding var isPresented: Bool
    @Binding var searchText: String

    var body: some View {
        VStack(spacing: 20) {
            TextField("", text: $searchText, prompt: Text("Search \(title)").foregroundColor(.black))
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(8)
                .padding(.horizontal)

            ScrollView {
                LazyVStack(alignment: .leading) {
                    let filtered = searchText.isEmpty
                    ? Array(items.prefix(60)).uniqued()
                    : Array(items.filter { $0.localizedCaseInsensitiveContains(searchText) }).uniqued()

                    ForEach(filtered, id: \.self) { item in
                        Button(action: {
                            if selection == item{
                                selection = ""
                            }else{
                                selection = item
                            }
                    
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                withAnimation {
                                    isPresented = false
                                }
                            }
                        }) {
                            HStack{
                                Text(item)
                                    .foregroundColor(.black)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                if selection == item {
                                   
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.black)
                                }
                            }
                            .background(selection == item ? Color.gray.opacity(0.2) : Color.clear)
                        }
                        Divider()
                    }
                }
                .background(Color.white)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding(.top, 140)
        .shadow(radius: 10)
        .transition(.move(edge: .top))
        .zIndex(1)
    }
}


extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}
