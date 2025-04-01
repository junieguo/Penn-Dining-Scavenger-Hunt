//
//  DiningHallViewModel.swift
//  Penn Dining Scavenger Hunt
//

import Foundation
import CoreLocation
import MapKit
import CoreMotion

@Observable
class DiningHallViewModel: NSObject, CLLocationManagerDelegate {
    var diningHalls: [DiningHall] = []
    var currentLocation: CLLocation?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var locationError: Error?
    var currentDiningHall: DiningHall?
    
    private let locationManager = CLLocationManager()
    private let motionManager = CMMotionManager()
    private var isRequestingLocation = false
    private var isMonitoringMotion = false
    private let locationPermissionKey = "hasRequestedLocationPermission"

    var hasRequestedLocationPermission: Bool {
        get { UserDefaults.standard.bool(forKey: locationPermissionKey) }
        set { UserDefaults.standard.set(newValue, forKey: locationPermissionKey) }
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        initializeDiningHalls()
        requestLocationPermission()
        setupMotionManager()
    }
    
    private func initializeDiningHalls() {
        self.diningHalls = [
            DiningHall(name: "1920 Commons", location: CLLocation(latitude: 39.95248, longitude: -75.19938)),
            DiningHall(name: "Accenture Café", location: CLLocation(latitude: 39.95202, longitude: -75.19135)),
            DiningHall(name: "Falk Kosher Dining", location: CLLocation(latitude: 39.95314, longitude: -75.20015)),
            DiningHall(name: "Hill House", location: CLLocation(latitude: 39.95300, longitude: -75.19071)),
            DiningHall(name: "Houston Market", location: CLLocation(latitude: 39.95091, longitude: -75.19388)),
            DiningHall(name: "Joe's Café", location: CLLocation(latitude: 39.95156, longitude: -75.19652)),
            DiningHall(name: "Kings Court English House", location: CLLocation(latitude: 39.95416, longitude: -75.19418)),
            DiningHall(name: "Lauder College House", location: CLLocation(latitude: 39.95382, longitude: -75.19108)),
            DiningHall(name: "McClelland Express", location: CLLocation(latitude: 39.95107, longitude: -75.19839)),
            DiningHall(name: "Pret A Manger", location: CLLocation(latitude: 39.95263, longitude: -75.19848)),
            DiningHall(name: "Quaker Kitchen", location: CLLocation(latitude: 39.95354, longitude: -75.20198))
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
            startLocationUpdates()
        default: break
        }
    }
    
    func startLocationUpdates() {
        guard !isRequestingLocation else { return }
        isRequestingLocation = true
        guard CLLocationManager.locationServicesEnabled() else {
            locationError = NSError(domain: "LocationServicesDisabled", code: -1)
            isRequestingLocation = false
            return
        }
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        isRequestingLocation = false
        currentLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isRequestingLocation = false
        locationError = error
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
        return distance <= 50
    }
    
    // MARK: - Shake Detection
    
    private func setupMotionManager() {
        guard motionManager.isAccelerometerAvailable else {
            print("Accelerometer not available")
            return
        }
        motionManager.accelerometerUpdateInterval = 0.1
    }
    
    func startMonitoringShake() {
        guard !isMonitoringMotion else { return }
        isMonitoringMotion = true
        
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let self = self, let data = data else { return }
            
            let threshold = 1.5
            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            
            if abs(x) > threshold || abs(y) > threshold || abs(z) > threshold {
                self.handleShake()
            }
        }
    }
    
    func stopMonitoringShake() {
        guard isMonitoringMotion else { return }
        motionManager.stopAccelerometerUpdates()
        isMonitoringMotion = false
    }
    
    private func handleShake() {
        guard let diningHall = currentDiningHall,
              isUserNearby(diningHall: diningHall),
              !diningHall.isCollected else { return }
        
        collectDiningHall(diningHall: diningHall)
    }
    
    func setCurrentDiningHall(_ diningHall: DiningHall) {
        currentDiningHall = diningHall
    }
}
