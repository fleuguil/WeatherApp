//
//  Forecast.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/19.
//

import Foundation

struct Forecast: Decodable {
    let city: ForecastCity
    let list: [ForecastPeriod]
}

struct ForecastCity: Decodable {
    let name: String
}

struct ForecastPeriod: Identifiable, Codable {
    var id = UUID()
    let date: Date
    let temperature: Double
    let description: String?
    let icon: String?
}
