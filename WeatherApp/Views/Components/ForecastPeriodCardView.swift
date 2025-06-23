//
//  ForebasePeriodCardView.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/21.
//

import SwiftUI

struct ForecastPeriodCardView: View {
    let forecastPeriod: ForecastPeriod
    
//    let dayFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.locale = Locale.current
//        formatter.dateFormat = "EEEE" // Full weekday name
//        return formatter
//    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short // Will respect the user's locale (e.g., 3:00 PM or 15:00)
        formatter.dateStyle = .none
        return formatter
    }()

    var body: some View {
        WeatherInfoCardView(title: timeFormatter.string(from: forecastPeriod.date),
                            temperature: "\(Int(round(forecastPeriod.temperature)))°",
                            description: forecastPeriod.description ?? Strings.notAvailable,
                            iconCode: forecastPeriod.icon)
    }
}

#Preview {
    ForecastPeriodCardView(forecastPeriod: ForecastPeriod(date: Date(), temperature: 30, description: "sunny", icon: "01d"))
}

