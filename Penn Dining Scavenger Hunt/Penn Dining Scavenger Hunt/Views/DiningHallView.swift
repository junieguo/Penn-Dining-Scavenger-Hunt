//
//  DiningHallView.swift
//  Penn Dining Scavenger Hunt
//

import SwiftUI
import CoreLocation

struct DiningHallView: View {
    var diningHall: DiningHall
    
    var body: some View {
        Text("Dining Hall View for \(diningHall.name)")
            .navigationTitle(diningHall.name)
    }
}

#Preview {
    DiningHallView(diningHall: DiningHall(name: "Example", location: CLLocation(latitude: 0, longitude: 0)))
}
