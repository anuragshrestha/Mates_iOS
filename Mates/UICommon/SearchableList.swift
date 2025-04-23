////
////  SearchableList.swift
////  Mates
////
////  Created by Anurag Shrestha on 4/19/25.
////
//
//import SwiftUI
//
//struct SearchableList: View {
//    var title: String
//    var items: [String]
//    @Binding var selectedItem: String
//    @Environment(\.dismiss) var dismiss
//    
//    @State private var searchText = ""
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(items.filter {
//                    searchText.isEmpty || $0.localizedCaseInsensitiveContains(searchText)
//                }, id: \.self) { item in
//                    Button(action: {
//                        selectedItem = item
//                        dismiss()
//                    }) {
//                        Text(item)
//                    }
//                }
//            }
//            .navigationTitle(title)
//            .searchable(text: $searchText)
//        }
//    }
//}
//
//
