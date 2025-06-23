//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/19.
//

import Foundation

final class WeatherRepository: WeatherRepositoryProtocol {
    private let session: URLSession = .shared
    private let baseURL = Config.baseURL
    private let apiKey: String
    private let forecastCache = ForecastCache() // 他のところに使わない、singletonの必要はない

    // ローカルによって回答内容が変わります
    private let currentLocale = Locale.current.language.languageCode?.identifier ?? Config.defaultLocale

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func fetchForecasts(for lat: Double, lon: Double) async throws -> Forecast {
        // cacheにあるか
        if let cached = forecastCache.loadIfValid(lat: lat, lon: lon, locale: currentLocale) {
            do {
                let decoded = try JSONDecoder().decode(ForecastResponse.self, from: cached)
                return Forecast(city: ForecastCity(name: decoded.city.name), list: decoded.list.map {
                    ForecastPeriod(
                        date: Date(timeIntervalSince1970: $0.dt),
                        temperature: $0.main.temp,
                        description: $0.weather.first?.description, icon: $0.weather.first?.icon
                    )
                })
            } catch {
                // かなり致命的、キャッシュをclean up, APIから読み込む
                forecastCache.cleanUp(force: true)
                print("cache corrupted: \(error)")
            }
        }

        var components = URLComponents(string: Config.APIPath.forecast)!
        components.queryItems = [
            // 10 meters accuracy, more than enough
            URLQueryItem(name: "lat", value: String(format: "%.4f", lat)),
            URLQueryItem(name: "lon", value: String(format: "%.4f", lon)),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: Config.defaultUnits),
            URLQueryItem(name: "lang", value: currentLocale),
        ]
        guard let url = components.url(relativeTo: baseURL) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        do {
            try forecastCache.save(data: data, lat: lat, lon: lon, locale: currentLocale)
        } catch {
            // 致命的、デバイスのspaceがないのか。
            forecastCache.cleanUp(force: true)
            print("cache corrupted: \(error)")
        }

        let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)

        return Forecast(city: ForecastCity(name: decoded.city.name), list: decoded.list.map {
            ForecastPeriod(
                date: Date(timeIntervalSince1970: $0.dt),
                temperature: $0.main.temp,
                description: $0.weather.first?.description, icon: $0.weather.first?.icon
            )
        })
    }

    func searchLocations(query: String) async throws -> [WeatherLocation] {
        var components = URLComponents(string: Config.APIPath.direct)!
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: Config.defaultDirectLimit),
            URLQueryItem(name: "appid", value: apiKey),
        ]
        guard let url = components.url(relativeTo: baseURL) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await session.data(from: url)

        // 細かいエラーはハンドリングしない
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let results = try JSONDecoder().decode([DirectResponse].self, from: data)

        return results.map {
            WeatherLocation(
                // currentローカルがない場合はnameをcurrentローカルにする
                names: $0.local_names?[currentLocale] != nil ? $0.local_names : ($0.local_names ?? [:]).merging([self.currentLocale: $0.name]) { current, _ in current },
                lat: $0.lat,
                lon: $0.lon
            )
        }
    }

    func fetchCurrentWeather(for lat: Double, lon: Double) async throws -> CurrentWeather {
        var components = URLComponents(string: Config.APIPath.weather)!
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(format: "%.4f", lat)),
            URLQueryItem(name: "lon", value: String(format: "%.4f", lon)),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            // 仕様書では「ja固定」が、jaをデフォルトにする、その他も対応
            URLQueryItem(name: "lang", value: currentLocale),
        ]
        guard let url = components.url(relativeTo: baseURL) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await session.data(from: url)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let result = try JSONDecoder().decode(WeatherResponse.self, from: data)

        return CurrentWeather(name: result.name,
                              description: result.weather.first?.description,
                              icon: result.weather.first?.icon,
                              temp: result.main.temp)
    }
}
