//
//  HomeView.swift
//  Penn Dining Scavenger Hunt
//

import SwiftUI

struct HomeView: View {
    @Environment(DiningHallViewModel.self) private var viewModel
    
    var body: some View {
        NavigationStack {
            List(viewModel.diningHalls) { diningHall in
                NavigationLink {
                    DiningHallView(diningHall: diningHall)
                } label: {
                    HStack {
                        Text(diningHall.name)
                            .font(.body)
                        Spacer()
                        if diningHall.isCollected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Penn Dining Hunt")
        }
    }
}

#Preview {
    HomeView()
        .environment(DiningHallViewModel())
}
