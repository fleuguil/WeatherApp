//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/19.
//

import Foundation

struct ForecastResponse: Codable {
    let list: [WeatherData]
    let city: City
}

struct WeatherData: Codable {
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let icon: String
    let description: String
}

struct City: Codable {
    let name: String // should be in the requested locale
    let coord: Coordinates
}

struct Coordinates: Codable, Hashable, Equatable {
    let lon: Double
    let lat: Double
}
