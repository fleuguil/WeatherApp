//
//  WeatherRepositoryProtocol.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/19.
//

import Foundation

// テスト・モックするため、protocolを定義
protocol WeatherRepositoryProtocol {
    func fetchForecasts(for lat: Double, lon: Double) async throws -> Forecast
    func searchLocations(query: String) async throws -> [WeatherLocation]
    func fetchCurrentWeather(for lat: Double, lon: Double) async throws -> CurrentWeather
}
