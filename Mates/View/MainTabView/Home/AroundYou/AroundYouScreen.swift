//
//  AroundYouScreen.swift
//  Mates
//
//  Created by Anurag Shrestha on 6/17/25.
//

import SwiftUI

struct AroundYouScreen: View {
    @ObservedObject var vm: FeedViewModel
    
    
    var body: some View { FeedListScreen(vm: vm) }
}
