//
//  File.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/21.
//

import Foundation
import SwiftUI


struct WeatherLocationCardView: View {
    let weatherLocation: WeatherLocation? // when nil, current location
 
    var body: some View {
        let temperature: String
        if let temp = weatherLocation?.currentWeather?.temp {
            temperature = "\(Int(round(temp)))°"
        } else {
            temperature = "--°"
        }

        let locationName = weatherLocation?.names?[Locale.current.language.languageCode?.identifier ?? Config.defaultLocale] ?? Strings.Home.currentLocation
        let description = weatherLocation?.currentWeather?.description ?? Strings.notAvailable
        let iconCode = weatherLocation?.currentWeather?.icon

        return WeatherInfoCardView(
            title: locationName,
            temperature: temperature,
            description: description,
            iconCode: iconCode
        )
    }
}

#Preview {
    WeatherLocationCardView(weatherLocation: WeatherLocation(names: ["en": "Tokyo","ja":"東京"], lat: 0, lon: 0, currentWeather: CurrentWeather(name: "", description: "sunny", icon: "01d", temp: 30)))
}
