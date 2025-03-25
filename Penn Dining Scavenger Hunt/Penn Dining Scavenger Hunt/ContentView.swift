//
//  ContentView.swift
//  Penn Dining Scavenger Hunt
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView()
    }
}

#Preview {
    ContentView()
        .environment(DiningHallViewModel())
}
