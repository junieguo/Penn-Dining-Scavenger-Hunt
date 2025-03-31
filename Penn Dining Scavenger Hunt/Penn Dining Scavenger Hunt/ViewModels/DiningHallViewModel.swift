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
    private let locationPermissionKey = "hasRequestedLocationPermission"

    var hasRequestedLocationPermission: Bool {
        get {
            UserDefaults.standard.bool(forKey: locationPermissionKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: locationPermissionKey)
        }
    }
    
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
    
    func requestLocationPermission() {
        if !hasRequestedLocationPermission {
            hasRequestedLocationPermission = true
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location authorized")
            startLocationUpdates()
        case .denied, .restricted:
            print("Location access denied")
        case .notDetermined:
            print("Authorization status not determined yet")
        @unknown default:
            print("Unknown authorization status")
        }
    }
    
    func startLocationUpdates() {
        guard !isRequestingLocation else { return }
        isRequestingLocation = true
        
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location services are not enabled")
            locationError = NSError(domain: "LocationServicesDisabled", code: -1)
            isRequestingLocation = false
            return
        }
        
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isRequestingLocation = false
        guard let location = locations.last else { return }
        
        currentLocation = location
        locationError = nil
        
        // Print for debugging
        print("Updated location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isRequestingLocation = false
        locationError = error
        print("Location manager error: \(error.localizedDescription)")
    }
    
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
        let distance = userLocation.distance(from: diningHall.location)
        print("Distance to \(diningHall.name): \(distance) meters")
        return distance <= 50
    }
}
