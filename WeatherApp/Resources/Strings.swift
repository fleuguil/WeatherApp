//
//  Strings.swift
//  WeatherApp
//
//  Created by Guillaume Fleury on 2025/06/19.
//

import Foundation

import Foundation

enum Strings {
    static let ok = String(localized: "OK")
    static let error = String(localized: "Error")
    static let notAvailable = String(localized: "N/A")

    enum Home {
        static var title: String {
            String(localized: "Weather")
        }

        static var searchPlaceholder: String {
            String(localized: "Search for a place")
        }

        static var currentLocation: String {
            String(localized: "Current Location")
        }

        static var locationDenied: String {
            String(localized: "Location access is denied. Please enable it in Settings to use this feature.")
        }
    }

    enum LocationPermissionExplanation {
        static var enableLocation: String {
            String(localized: "Enable Location")
        }

        static var description: String {
            String(localized: "We need your location to provide the most accurate weather forecast for where you are right now.")
        }

        static var allowLocation: String {
            String(localized: "Allow Location")
        }
    }

    enum Weather {
        static var loading: String {
            String(localized: "Loading...")
        }

        static var retry: String {
            String(localized: "Retry")
        }
    }

    enum Error {
        static var serverResponse: String {
            String(localized: "The server is not responding. Please try again later.")
        }

        static var badURL: String {
            String(localized: "Something went wrong with the request. Please try again.")
        }

        static var timeout: String {
            String(localized: "The request timed out. Please check your connection and try again.")
        }

        static var noInternet: String {
            String(localized: "No internet connection. Please check your settings.")
        }

        static var genericRequest: String {
            String(localized: "Could not complete the request. Please try again.")
        }

        static var decoding: String {
            String(localized: "We couldn’t read the data from the server. Please try again later.")
        }

        static var unknown: String {
            String(localized: "An unexpected error occurred. Please try again.")
        }

        static var emptyForecast: String {
            String(localized: "No forecast data available for this location.")
        }

        static var failedSearch: String {
            String(localized: "Failed to search for location. Please try again.")
        }
    }
}
