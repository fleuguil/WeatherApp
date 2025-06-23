//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/19.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    init() {
        // mainスレードでやるけど、そんなに時間がかからない
        ForecastCache().cleanUp()
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
