//
//  Constants.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/19.
//

import Foundation

enum Constants {
    enum DefaultFavoriteLocations {
        // direct APIから習得する情報 (座標と多言語の地名)
        static let all: [WeatherLocation] =
            [WeatherLocation(names: ["en": "Tokyo", "ja": "東京"], lat: 35.6895, lon: 139.6917),
             WeatherLocation(names: ["en": "Hyogo", "ja": "兵庫"], lat: 35.0403, lon: 134.826),
             WeatherLocation(names: ["en": "Oita", "ja": "大分"], lat: 33.2381, lon: 131.6125),
             WeatherLocation(names: ["en": "Hokkaido", "ja": "北海道"], lat: 43.0645, lon: 141.3466)]
    }
}
