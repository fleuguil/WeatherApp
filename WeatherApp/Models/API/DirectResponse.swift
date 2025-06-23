//
//  FoundLocation.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/21.
//

import Foundation

struct DirectResponse: Decodable {
    let name: String
    let local_names: [String: String]?
    let lat: Double
    let lon: Double

}
