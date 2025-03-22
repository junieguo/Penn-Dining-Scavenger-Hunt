//
//  DiningHall.swift
//  Penn Dining Scavenger Hunt
//

import CoreLocation

struct DiningHall: Identifiable {
    var id: UUID = UUID()
    var name: String
    var location: CLLocation
    var isCollected: Bool = false
}
