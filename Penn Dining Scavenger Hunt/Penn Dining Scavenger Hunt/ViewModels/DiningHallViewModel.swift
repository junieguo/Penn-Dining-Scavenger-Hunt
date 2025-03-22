//
//  DiningHallViewModel.swift
//  Penn Dining Scavenger Hunt
//

import Foundation
import CoreLocation

@Observable class DiningHallViewModel: ObservableObject {
    @Published var diningHalls: [DiningHall] = []
    
    // Method to mark a dining hall as collected
    func collectDiningHall(diningHall: DiningHall) {
        if let index = diningHalls.firstIndex(where: { $0.id == diningHall.id }) {
            diningHalls[index].isCollected = true
        }
    }

    // Method to check if a dining hall has been collected
    func isDiningHallCollected(diningHall: DiningHall) -> Bool {
        return diningHall.isCollected
    }
    
    // Initialize with a list of dining halls
    init() {
        self.diningHalls = [
            DiningHall(name: "Example", location: CLLocation(latitude: 0, longitude: 0)),
        ]
    }
}
