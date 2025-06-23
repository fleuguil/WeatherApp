//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/21.
//

import Foundation

struct WeatherResponse: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String
}
