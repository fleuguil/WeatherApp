//
//  MockLocationManager.swift
//  WeatherAppTests
//
//  Created by Guillaume Fleury on 2025/06/22.
//

import Foundation
import CoreLocation
@testable import WeatherApp

final class MockLocationManager: LocationManagerProtocol {
    var currentLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    var isAuthorized: Bool = false
    var requestAuthorizationResult: Bool = false

    func requestAuthorization() async -> Bool {
        return requestAuthorizationResult
    }
}
