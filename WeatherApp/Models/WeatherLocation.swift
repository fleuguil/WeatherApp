//
//  FavoriteLocation.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/20.
//

import Foundation

struct WeatherLocation: Hashable {
    let names: [String: String]? // ["en": "Hokkaido", "ja": "北海道"]、現在地の場合、地名はわからない
    let lat: Double
    let lon: Double
    var currentWeather: CurrentWeather?
}
