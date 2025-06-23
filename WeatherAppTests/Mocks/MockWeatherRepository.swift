//
//  MockWeatherRepository.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/19.
//

import Foundation
@testable import WeatherApp

final class MockWeatherRepository: WeatherRepositoryProtocol {
    func fetchCurrentWeather(for lat: Double, lon: Double) async throws -> CurrentWeather {
        return CurrentWeather(name: "SomePlace", description: "Sunny", icon: "10d", temp: 20)
    }
    
    func searchLocations(query: String) async throws -> [WeatherLocation] {
        [WeatherLocation(names: ["en":"Tokyo","ja":"東京"], lat: 35.6895, lon: 139.6917),
         WeatherLocation(names: ["en":"Hyogo","ja":"兵庫"], lat: 35.0403, lon: 134.826)]
    }
    
    func fetchForecasts(for lat: Double, lon: Double) async throws -> Forecast {
        return try await fetchForecasts(for: "Tokyo")
    }
    
    func fetchForecasts(for city: String) async throws -> Forecast {
        return Forecast(city: ForecastCity(name: "Tokyo"), list: [
            ForecastPeriod(date: Date(), temperature: 25, description: "Sunny", icon: "01d"),
            ForecastPeriod(date: Date().addingTimeInterval(3600), temperature: 23, description: "Sunny", icon: "02d")
        ])
    }
}
