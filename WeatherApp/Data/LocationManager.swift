//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/20.
//

import Foundation
import CoreLocation

// https://www.createwithswift.com/updating-the-users-location-with-core-location-and-swift-concurrency-in-swiftui/
class LocationManager: NSObject, CLLocationManagerDelegate, LocationManagerProtocol {
    
    //MARK: Object to Access Location Services
    private let locationManager = CLLocationManager()
    
    //MARK: Set up the Location Manager Delegate
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    //MARK: Continuation Object for the User Location
    private var continuation: CheckedContinuation<CLLocation, Error>?
    private var authContinuation: CheckedContinuation<Bool, Never>?
    
    // Error messages associated with the location manager
    enum LocationManagerError: String, Error {
        case replaceContinuation = "Continuation replaced."
        case locationNotFound = "No location found."
    }
    
    //MARK: Async Request the Current Location
    var currentLocation: CLLocation {
        get async throws {
            // Check if there is a continuation being worked on
            if self.continuation != nil {
                // If so, resumes it throwing an error
                self.continuation?.resume(throwing: LocationManagerError.replaceContinuation)
                // And deletes it, so a new one can be created
                self.continuation = nil
            }
            
            return try await withCheckedThrowingContinuation { continuation in
                // 1. Set up the continuation object
                self.continuation = continuation
                // 2. Triggers the update of the current location
                locationManager.requestLocation()
            }
        }
    }
    
    var isAuthorized: Bool {
        switch locationManager.authorizationStatus {
            case .notDetermined:
                return false
            case .authorizedWhenInUse, .authorizedAlways:
                return true
            case .denied, .restricted:
                return false
            @unknown default:
                return true // don't do anything
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 4. If there is a location available
        if let lastLocation = locations.last {
            // 5. Resumes the continuation object with the user location as result
            continuation?.resume(returning: lastLocation)
            // Resets the continuation object
            continuation = nil
        } else {
            // If there is no location, resumes the continuation throwing and error to avoid a continuation leak
            continuation?.resume(throwing: LocationManagerError.locationNotFound)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 6. If not possible to retrieve a location, resumes with an error
        continuation?.resume(throwing: error)
        // Resets the continuation object
        continuation = nil
    }
    
    func requestAuthorization() async -> Bool {
        let status = locationManager.authorizationStatus

        if status == .authorizedAlways || status == .authorizedWhenInUse {
            return true
        }

        if status == .notDetermined {
            return await withCheckedContinuation { continuation in
                self.authContinuation = continuation
                locationManager.requestWhenInUseAuthorization()
            }
        }

        return false // .restricted or .denied
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if let continuation = authContinuation {
            let newStatus = manager.authorizationStatus
            let granted = (newStatus == .authorizedAlways || newStatus == .authorizedWhenInUse)
            continuation.resume(returning: granted)
            authContinuation = nil
        }
    }    
}
