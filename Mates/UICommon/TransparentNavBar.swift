//
//  TransparentNavBar.swift
//  Mates
//
//  Created by Anurag Shrestha on 7/22/25.
//

import SwiftUI

extension View {
    func transparentNavBar() -> some View {
        self.onAppear {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
