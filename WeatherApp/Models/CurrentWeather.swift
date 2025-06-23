//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/21.
//

import Foundation

struct CurrentWeather: Hashable {
    let name: String // in requested locale
    let description: String?
    let icon: String?
    let temp: Double
}
