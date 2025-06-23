//
//  Config.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/19.
//

import Foundation

enum Config {
    static let baseURL = URL(string: "https://api.openweathermap.org")!
    static var apiKey: String {
        Bundle.main.infoDictionary?["WEATHER_API_KEY"] as? String ?? ""
    }

    static let supportedLocales = ["ja"] // in addition to defaultLanguage
    static let defaultLocale = "en"
    static let defaultUnits = "metric"
    static let defaultDirectLimit = "5"

    enum APIPath {
        static let forecast = "data/2.5/forecast"
        static let direct = "geo/1.0/direct"
        static let weather = "data/2.5/weather"
    }
}
