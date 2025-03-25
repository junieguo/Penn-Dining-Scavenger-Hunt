//
//  Penn_Dining_Scavenger_HuntApp.swift
//  Penn Dining Scavenger Hunt
//

import SwiftUI

@main
struct Penn_Dining_Scavenger_HuntApp: App {
    @State private var viewModel = DiningHallViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel)
        }
    }
}
