//
//  Config.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/19.
//

import Foundation

enum Config {
    static let baseURL = URL(string: "https://api.openweathermap.org")!
    // TODO: set your openweathermap API key here
    static var apiKey: String {
//    #if WEATHER_API_KEY
//        return WEATHER_API_KEY
//    #else
//        return ""
//    #endif
            Bundle.main.infoDictionary?["WEATHER_API_KEY"] as? String ?? ""
////            Bundle.main.object(forInfoDictionaryKey: "WEATHER_API_KEY") as? String
        }
//    static let apiKey = "058c9fc7532344acdd2db81506db27ad"
//    static let apiKey = ""
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
