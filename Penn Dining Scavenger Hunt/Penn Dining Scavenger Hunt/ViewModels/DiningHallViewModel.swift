//
//  DiningHallViewModel.swift
//  Penn Dining Scavenger Hunt
//

import Foundation
import CoreLocation

@Observable
class DiningHallViewModel {
    var diningHalls: [DiningHall] = []
    
    // Method to mark a dining hall as collected
    func collectDiningHall(diningHall: DiningHall) {
        if let index = diningHalls.firstIndex(where: { $0.id == diningHall.id }) {
            diningHalls[index].isCollected = true
        }
    }

    // Method to check if a dining hall has been collected
    func isDiningHallCollected(diningHall: DiningHall) -> Bool {
        diningHalls.first(where: { $0.id == diningHall.id })?.isCollected ?? false
    }
    
    // Initialize with all Penn dining halls
    init() {
        self.diningHalls = [
            DiningHall(name: "1920 Commons",
                      location: CLLocation(latitude: 0, longitude: 0)),
            DiningHall(name: "Accenture Café",
                      location: CLLocation(latitude: 0, longitude: 0)),
            DiningHall(name: "Falk Kosher Dining",
                      location: CLLocation(latitude: 0, longitude: 0)),
            DiningHall(name: "Hill House",
                      location: CLLocation(latitude: 0, longitude: 0)),
            DiningHall(name: "Houston Market",
                      location: CLLocation(latitude: 0, longitude: 0)),
            DiningHall(name: "Joe's Café",
                      location: CLLocation(latitude: 0, longitude: 0)),
            DiningHall(name: "Kings Court English House",
                      location: CLLocation(latitude: 0, longitude: 0)),
            DiningHall(name: "Lauder College House",
                      location: CLLocation(latitude: 0, longitude: 0)),
            DiningHall(name: "McClelland Express",
                      location: CLLocation(latitude: 0, longitude: 0)),
            DiningHall(name: "Pret A Manger",
                      location: CLLocation(latitude: 0, longitude: 0)),
            DiningHall(name: "Quaker Kitchen",
                      location: CLLocation(latitude: 0, longitude: 0))
        ]
    }
}
