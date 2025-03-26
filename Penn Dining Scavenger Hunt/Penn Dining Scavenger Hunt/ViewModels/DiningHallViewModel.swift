//
//  DiningHallViewModel.swift
//  Penn Dining Scavenger Hunt
//

import Foundation
import CoreLocation
import MapKit

@Observable
class DiningHallViewModel: NSObject, CLLocationManagerDelegate {
    var diningHalls: [DiningHall] = []
    var currentLocation: CLLocation?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var locationError: Error?
    
    private let locationManager = CLLocationManager()
    private var isRequestingLocation = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        initializeDiningHalls()
        requestLocationPermission()
    }
    
    private func initializeDiningHalls() {
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
    
    // Location Management
    func requestLocationPermission() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            startLocationUpdates()
        default:
            break
        }
    }
    
    func startLocationUpdates() {
        guard !isRequestingLocation else { return }
        isRequestingLocation = true
        locationManager.requestLocation()
    }
    
    // Dining Hall Collection
    func collectDiningHall(diningHall: DiningHall) {
        if let index = diningHalls.firstIndex(where: { $0.id == diningHall.id }) {
            diningHalls[index].isCollected = true
        }
    }
    
    func isDiningHallCollected(diningHall: DiningHall) -> Bool {
        diningHalls.first(where: { $0.id == diningHall.id })?.isCollected ?? false
    }
    
    func isUserNearby(diningHall: DiningHall) -> Bool {
        guard let userLocation = currentLocation else { return false }
        return userLocation.distance(from: diningHall.location) <= 50
    }
    
    // CLLocationManagerDelegate
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            startLocationUpdates()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isRequestingLocation = false
        currentLocation = locations.last
        locationError = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isRequestingLocation = false
        locationError = error
        print("Location manager error: \(error.localizedDescription)")
    }
}
