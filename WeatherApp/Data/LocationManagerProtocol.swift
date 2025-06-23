//
//  LocationManagerProtocol.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/22.
//

import Foundation

import CoreLocation

protocol LocationManagerProtocol {
    var currentLocation: CLLocation { get async throws }
    var isAuthorized: Bool { get }
    func requestAuthorization() async -> Bool
}
