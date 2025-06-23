//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/19.
//

import Foundation

enum NoForecastError: Error {
    case general
}

@Observable
final class WeatherViewModel {
    let weatherLocation: WeatherLocation

    var forecast: Forecast?
    var groupedByDateForecasts: [(Date, [ForecastPeriod])] {
        // 過去のforecastはremoveする
        let forecastPeriods = (forecast?.list ?? []).filter { $0.date >= Date() }

        return Dictionary(grouping: forecastPeriods) { forecastPeriod in
            Calendar.current.startOfDay(for: forecastPeriod.date)
        }
        .mapValues { dayForecasts in
            dayForecasts.sorted { $0.date < $1.date }
        }
        .sorted { $0.key < $1.key }
    }

    var isLoading: Bool = false
    var errorMessage: String?

    private let repository: WeatherRepositoryProtocol

    var locationName: String {
        // what was passed
        let locationName = weatherLocation.names?[Locale.current.language.languageCode?.identifier ?? ""]
        let cityName = forecast?.city.name

        return {
            switch (locationName, cityName) {
            case let (loc?, city?) where loc != city:
                return "\(loc) (\(city))"
            case let (loc?, _):
                return loc
            case let (_, city?):
                return city
            default:
                return Strings.notAvailable
            }
        }()
    }

    init(weatherLocation: WeatherLocation, repository: WeatherRepositoryProtocol) {
        self.weatherLocation = weatherLocation
        self.repository = repository
    }

    func fetch() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            forecast = try await repository.fetchForecasts(for: weatherLocation.lat, lon: weatherLocation.lon)

            // empty forecast?
            if forecast?.list.isEmpty == true {
                throw NoForecastError.general
            }
        } catch let urlError as URLError {
            forecast = nil
            switch urlError.code {
            case .badServerResponse:
                errorMessage = Strings.Error.serverResponse
            case .badURL:
                errorMessage = Strings.Error.badURL
            case .timedOut:
                errorMessage = Strings.Error.timeout
            case .notConnectedToInternet:
                errorMessage = Strings.Error.noInternet
            default:
                errorMessage = Strings.Error.unknown
            }
        } catch _ as DecodingError {
            forecast = nil
            errorMessage = Strings.Error.decoding
        } catch _ as NoForecastError {
            errorMessage = Strings.Error.emptyForecast
        } catch {
            forecast = nil
            errorMessage = Strings.Error.unknown
        }
    }
}
