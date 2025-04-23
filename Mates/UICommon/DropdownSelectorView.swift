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
                .cornerRadius(8)
                .padding(.horizontal)

            ScrollView {
                LazyVStack(alignment: .leading) {
                    let filtered = searchText.isEmpty
                        ? Array(items.prefix(60))
                        : items.filter { $0.localizedCaseInsensitiveContains(searchText) }

                    ForEach(filtered, id: \.self) { item in
                        Button(action: {
                            selection = item
                            isPresented = false
                        }) {
                            Text(item)
                                .foregroundColor(.black)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Divider()
                    }
                }
                .background(Color.white)
            }
            .frame(maxHeight: 300)
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
